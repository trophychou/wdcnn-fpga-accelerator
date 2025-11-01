/**
 * Copyright (c) @CompanyNameMagicTag 2022. All rights reserved.
 *
 * Description: SLE private service register sample of client.
 */
#include <stddef.h>
#include <stdbool.h>
#include <unistd.h>
#include <pthread.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/msg.h>
#include <sys/stat.h>
#include <sched.h>
#include "securec.h"
#include "sle_common.h"
#include "sle_device_discovery.h"
#include "sle_connection_manager.h"
#include "sle_ssap_client.h"
#include "sle_errcode.h"
#include "soc_osal.h"
#include "sle_uuid_client.h"

#undef THIS_FILE_ID
#define THIS_FILE_ID BTH_GLE_SAMPLE_UUID_CLIENT

#define SLE_DATA_SIZE_DEFAULT            200  // 73E可使用1450
#define SLE_SEEK_INTERVAL_DEFAULT        160  // 160
#define SLE_SEEK_WINDOW_DEFAULT          40  // 40
#define UUID_16BIT_LEN                   2
#define UUID_128BIT_LEN                  16
#define SPEED_DEFAULT_CONN_INTERVAL      0x10
#define SPEED_DEFAULT_TIMEOUT_MULTIPLIER 0x4b0
#define DATA_LEN                         251  // 设置datalen，73e用1530，73u用251
#define DEFAULT_SLE_SPEED_MCS            10
#define DEFAULT_SLE_SPEED_MTU_SIZE       1500

#define MS_100                           100000
#define THOUSAND                         1000
#define UUID_14_BYTE                     14
#define UUID_15_BYTE                     15

sle_announce_seek_callbacks_t g_seek_cbk = {0};
sle_connection_callbacks_t g_connect_cbk = {0};
ssapc_callbacks_t g_ssapc_cbk = {0};

static sle_uuid_t g_client_app_uuid = {UUID_16BIT_LEN, {0}};
static uint8_t g_client_id = 0;
static volatile uint8_t g_seek_once = 0;
static uint16_t g_connect_id = 0;
static uint16_t g_handle = 0;
static volatile uint8_t g_conn_cnt = 0;
static uint16_t g_handle_tbl[16] = {0};
static sle_addr_t g_conn_addr[16];
static uint8_t g_conn_live[16];
static uint8_t g_conn_hold[16];
static uint8_t g_hold_age[16];
static time_t g_last_conn;
static FILE *g_rx_fp = NULL;
static uint32_t g_rx_cnt = 0;
static uint8_t g_live_cnt = 0;
static sle_send_data_state_t g_send_flag = SEND_STATE_IDLE;
static sle_addr_t g_addr = {0};
static pthread_t g_send_thread = -1;

void sle_sample_sle_enable_cbk(errcode_t status)
{
    if (status != ERRCODE_SLE_SUCCESS) {
        printf("sle sample sle enable failed, status: %02x", status);
        return;
    }

    printf("sle sample sle enable success.\r\n");
    sle_start_scan();
    errcode_t ret = ssapc_register_client(&g_client_app_uuid, &g_client_id);
    if (ret != ERRCODE_SLE_SUCCESS) {
        printf("gattc_register_client failed, errcode: %d\r\n", ret);
        return;
    }
}

void sle_sample_seek_enable_cbk(errcode_t status)
{
    printf("sle sample seek enable status: %02x.\r\n", status);
}

void sle_sample_seek_disable_cbk(errcode_t status)
{
    printf("sle sample seek disable status: %02x.\r\n", status);
}

void sle_sample_seek_result_info_cbk(sle_seek_result_info_t *seek_result_data)
{
    printf("sle_sample_seek_result_info_cbk enter.\r\n");
    if (seek_result_data != NULL) {
        printf("SEEK #%d %02x:%02x:%02x:%02x:%02x:%02x\r\n", g_conn_cnt,
            seek_result_data->addr.addr[5], seek_result_data->addr.addr[4], seek_result_data->addr.addr[3],
            seek_result_data->addr.addr[2], seek_result_data->addr.addr[1], seek_result_data->addr.addr[0]);
        for (uint8_t k = 0; k < 16; k++) {
            if (g_conn_hold[k] &&
                memcmp(g_conn_addr[k].addr, seek_result_data->addr.addr, SLE_ADDR_LEN) == 0) {
                return;
            }
        }
        {
            uint8_t slot = 0xFF;
            uint8_t k;
            time_t now = time(NULL);
            for (k = 0; k < 16; k++) {
                if (!g_conn_hold[k]) { slot = k; break; }
            }
            if (slot != 0xFF && g_live_cnt < 7 && (now - g_last_conn) >= 4) {
                sle_addr_t peer = seek_result_data->addr;
                g_conn_hold[slot] = 1;
                g_hold_age[slot] = 0;
                memcpy_s(&g_conn_addr[slot], sizeof(sle_addr_t), &peer, sizeof(sle_addr_t));
                g_conn_cnt++;
                g_last_conn = now;
                (void)sle_connect_remote_device(&peer);
                printf("[ssap client] connecting slot=%d live=%d total %d\r\n", slot, g_live_cnt, g_conn_cnt);
            }
        }
    }
}

void sle_sample_seek_cbk_register(void)
{
    g_seek_cbk.sle_enable_cb = sle_sample_sle_enable_cbk;
    g_seek_cbk.seek_enable_cb = sle_sample_seek_enable_cbk;
    g_seek_cbk.seek_disable_cb = sle_sample_seek_disable_cbk;
    g_seek_cbk.seek_result_cb = sle_sample_seek_result_info_cbk;
}

void sle_sample_connect_state_changed_cbk(uint16_t conn_id, const sle_addr_t *addr, sle_acb_state_t conn_state,
    sle_pair_state_t pair_state, sle_disc_reason_t disc_reason)
{
    if (conn_state == SLE_ACB_STATE_CONNECTED) {
        g_connect_id = conn_id;
        {
            uint8_t slot = (uint8_t)(conn_id & 0x0F);
            if (!g_conn_live[slot]) {
                g_conn_live[slot] = 1;
                g_live_cnt++;
            }
            memcpy_s(&g_conn_addr[slot], sizeof(sle_addr_t), addr, sizeof(sle_addr_t));
            printf("[ssap client] live conn_id=%d peers=%d addr=%02x:%02x:%02x:%02x:%02x:%02x\r\n", conn_id, g_live_cnt, addr->addr[5], addr->addr[4], addr->addr[3], addr->addr[2], addr->addr[1], addr->addr[0]);
            {
                sle_connection_param_update_t up = {0};
                up.conn_id = conn_id;
                up.interval_min = 24;
                up.interval_max = 40;
                up.max_latency = 0;
                up.supervision_timeout = 1200;
                (void)sle_update_connect_param(&up);
            }
        }

        if (pair_state == SLE_PAIR_NONE) {
            printf("pair remote device.\r\n");
            sle_pair_remote_device(addr);
        }
    } else if (conn_state == SLE_ACB_STATE_DISCONNECTED) {
        printf("SLE disconnect. reason=0x%x conn_id=%d\n", disc_reason, conn_id);
        {
            uint8_t slot = (uint8_t)(conn_id & 0x0F);
            if (g_conn_live[slot]) {
                g_conn_live[slot] = 0;
                if (g_live_cnt) {
                    g_live_cnt--;
                }
            }
            g_conn_hold[slot] = 0;
            g_hold_age[slot] = 0;
            memset_s(&g_conn_addr[slot], sizeof(sle_addr_t), 0, sizeof(sle_addr_t));
        }
        g_seek_once = 0;
        g_conn_cnt = 0;
        sle_sample_send_thread_reset();
        sle_start_scan();
    }
}

void sle_sample_pair_complete_cbk(uint16_t conn_id, const sle_addr_t *addr, errcode_t status)
{
    printf("sle_sample_pair_complete_cbk status: %d\r\n", status);
    if (status != 0) {
        int8_t rm = (int8_t)sle_remove_paired_remote_device((sle_addr_t *)addr);
        printf("[ssap client] pair FAILED, remove bond ret=%d, will retry\r\n", rm);
        (void)sle_disconnect_remote_device((sle_addr_t *)addr);
        return;
    }
    sle_set_mcs(conn_id, DEFAULT_SLE_SPEED_MCS);

    sle_set_phy_t phy_parm = {
        .tx_format = SLE_RADIO_FRAME_2,
        .rx_format = SLE_RADIO_FRAME_2,
        .tx_phy = SLE_PHY_2M,  // 73E支持SLE_PHY_4M
        .rx_phy = SLE_PHY_2M,  // 73E支持SLE_PHY_4M
        .tx_pilot_density = SLE_PHY_PILOT_DENSITY_16_TO_1,
        .rx_pilot_density = SLE_PHY_PILOT_DENSITY_16_TO_1,
        .g_feedback = 0,
        .t_feedback = 0,
    };
    errcode_t ret2 = sle_set_phy_param(conn_id, &phy_parm);
    printf("[ssap client] set phy, ret: %d\r\n", ret2);
}

void sle_sample_update_cbk(uint16_t conn_id, errcode_t status, const sle_connection_param_update_evt_t *param)
{
    printf("[ssap client] updat state changed status %d conn_id:%d, interval = %02x\n",
           status, conn_id, param->interval);
    ssap_exchange_info_t info = {0};
    info.mtu_size = DEFAULT_SLE_SPEED_MTU_SIZE;
    info.version = 1;
    errcode_t ret = ssapc_exchange_info_req(g_client_id, conn_id, &info);
    printf("[ssap client] ssaps_set_info return: %d\r\n", ret);
}

void sle_sample_set_phy_cbk(uint16_t conn_id, errcode_t status, const sle_set_phy_t *param)
{
    printf("[ssap client] sle_sample_set_phy_cbk\r\n");

    // 更新连接参数
    sle_connection_param_update_t parame = {0};
    parame.conn_id = conn_id;
    parame.interval_min = SPEED_DEFAULT_CONN_INTERVAL;
    parame.interval_max = SPEED_DEFAULT_CONN_INTERVAL;
    parame.max_latency = 0;
    parame.supervision_timeout = SPEED_DEFAULT_TIMEOUT_MULTIPLIER;
    sle_update_connect_param(&parame);
}

void sle_sample_read_rssi_cbk(uint16_t conn_id, int8_t rssi, errcode_t status)
{
    printf("RSSI conn=%d val=%d status=%d\r\n", conn_id, rssi, status);
}

void sle_sample_connect_cbk_register(void)
{
    g_connect_cbk.connect_state_changed_cb = sle_sample_connect_state_changed_cbk;
    g_connect_cbk.pair_complete_cb = sle_sample_pair_complete_cbk;
    g_connect_cbk.connect_param_update_cb = sle_sample_update_cbk;
    g_connect_cbk.set_phy_cb = sle_sample_set_phy_cbk;
    g_connect_cbk.read_rssi_cb = sle_sample_read_rssi_cbk;
}

void sle_sample_exchange_info_cbk(uint8_t client_id, uint16_t conn_id, ssap_exchange_info_t *param, errcode_t status)
{
    printf("[ssap client] sle_sample_exchange_info_cbk\r\n");
    sle_set_data_len(conn_id, DATA_LEN);
    // 服务发现
    ssapc_find_structure_param_t find_param = {0};
    find_param.type = SSAP_FIND_TYPE_PRIMARY_SERVICE;
    find_param.start_hdl = 1;
    find_param.end_hdl = 0xFFFF;
    ssapc_find_structure(0, conn_id, &find_param);
}

void sle_sample_find_structure_cbk(
    uint8_t client_id, uint16_t conn_id, ssapc_find_service_result_t *service, errcode_t status)
{
    printf("[ssap client] find structure cbk client: %d conn_id:%d status: %d \n", client_id, conn_id, status);
    printf("[ssap client] find structure start_hdl:[0x%02x], end_hdl:[0x%02x], uuid len:%d\r\n",
        service->start_hdl,
        service->end_hdl,
        service->uuid.len);

    ssapc_find_structure_param_t find_param = {0};
    find_param.type = SSAP_FIND_TYPE_PROPERTY;
    find_param.start_hdl = 1;
    find_param.end_hdl = 0xFFFF;
    ssapc_find_structure(0, conn_id, &find_param);
}

void sle_sample_find_structure_cmp_cbk(
    uint8_t client_id, uint16_t conn_id, ssapc_find_structure_result_t *structure_result, errcode_t status)
{
    printf("[ssap client] find structure cmp cbk client id:%d status:%d type:%d uuid len:%d \r\n",
        client_id,
        status,
        structure_result->type,
        structure_result->uuid.len);
}

void sle_sample_find_property_cbk(
    uint8_t client_id, uint16_t conn_id, ssapc_find_property_result_t *property, errcode_t status)
{
    printf("[ssap client] find property cbk, client id: %d, conn id: %d, operate ind: %d, "
           "descriptors count: %d status:%d.\n",
        client_id,
        conn_id,
        property->operate_indication,
        property->descriptors_count,
        status);

    if (property->uuid.uuid[UUID_14_BYTE] == 0x23 && property->uuid.uuid[UUID_15_BYTE] == 0x23) {
        printf("[ssap client] find the target property, begin sending data.");
        g_handle = property->handle;
        g_handle_tbl[conn_id & 0x0F] = property->handle;
        g_send_flag = SEND_STATE_IDLE;
        {
            uint8_t cccd[2] = {0x00, 0x02};
            ssapc_write_param_t wp = {0};
            wp.handle = (uint16_t)(property->handle + 1);
            wp.type = SSAP_DESCRIPTOR_CLIENT_CONFIGURATION;
            wp.data_len = 2;
            wp.data = cccd;
            {
                errcode_t cccd_ret = ssapc_write_req(client_id, conn_id, &wp);
                printf("cccd write conn=%d hdl=0x%02x ret=%d\r\n", conn_id, wp.handle, (int)cccd_ret);
            }
        }
    } else {
        for (uint16_t idx = 0; idx < property->descriptors_count; idx++) {
            printf("[find_property_cbk]: %d value: %x", property->uuid.uuid[idx]);
        }
    }
}

void sle_sample_write_cfm_cbk(uint8_t client_id, uint16_t conn_id, ssapc_write_result_t *write_result, errcode_t status)
{
    printf("[ssap client] write cfm cbk, client id: %d status:%d.\n", client_id, status);
}

void sle_sample_read_cfm_cbk(uint8_t client_id, uint16_t conn_id, ssapc_handle_value_t *read_data, errcode_t status)
{
    printf("[ssap client] read cfm cbk client id: %d conn id: %d status: %d\n", client_id, conn_id, status);
    printf("[ssap client] read cfm cbk handle: %d, type: %d , len: %d\n",
        read_data->handle,
        read_data->type,
        read_data->data_len);
    for (uint16_t idx = 0; idx < read_data->data_len; idx++) {
        printf("[ssap client] read cfm cbk[%d] 0x%02x\r\n", idx, read_data->data[idx]);
    }
}

void sle_notification_cbk(uint8_t client_id, uint16_t conn_id, ssapc_handle_value_t *data, errcode_t status)
{
    if (g_rx_fp == NULL) {
        static char txbuf[1 << 20];
        g_rx_fp = fopen("/home/ubuntu/sw/wd_rx.bin", "wb");
        if (g_rx_fp != NULL) {
            (void)setvbuf(g_rx_fp, txbuf, _IOFBF, sizeof(txbuf));
        }
    }
    if (status == 0 && data != NULL && data->data_len > 0 && g_rx_fp != NULL) {
        (void)fwrite(data->data, 1, data->data_len, g_rx_fp);
        g_rx_cnt++;
        if ((g_rx_cnt & 0x3F) == 0) {
            (void)fflush(g_rx_fp);
        }
    }
}

void sle_sample_ssapc_cbk_register(void)
{
    g_ssapc_cbk.exchange_info_cb = sle_sample_exchange_info_cbk;
    g_ssapc_cbk.find_structure_cb = sle_sample_find_structure_cbk;
    g_ssapc_cbk.find_structure_cmp_cb = sle_sample_find_structure_cmp_cbk;
    g_ssapc_cbk.ssapc_find_property_cbk = sle_sample_find_property_cbk;
    g_ssapc_cbk.write_cfm_cb = sle_sample_write_cfm_cbk;
    g_ssapc_cbk.read_cfm_cb = sle_sample_read_cfm_cbk;
    g_ssapc_cbk.notification_cb = sle_notification_cbk;
}

void sle_start_scan(void)
{
    sle_seek_param_t param = {0};
    param.own_addr_type = 0;
    param.filter_duplicates = 0;
    param.seek_filter_policy = SLE_SEEK_FILTER_ALLOW_ALL;
    param.seek_phys = SLE_SEEK_PHY_1M;
    param.seek_type[0] = SLE_SEEK_ACTIVE;
    param.seek_interval[0] = SLE_SEEK_INTERVAL_DEFAULT;
    param.seek_window[0] = SLE_SEEK_WINDOW_DEFAULT;
    sle_set_seek_param(&param);

    sle_start_seek();
    return;
}

uint8_t sle_flow_ctrl_flag(void)
{
#ifdef SLE_QOS_FLOWCTRL_FUNCTION_SWITCH
    return (g_sle_link_state <= SLE_QOS_FLOWCTRL) ? 1 : 0;
#else
    return gle_tx_acb_data_num_get();
#endif
}

unsigned long M_TIME_TO_USEC(unsigned long tv_sec, unsigned long tv_usec)
{
    return (tv_sec * THOUSAND * THOUSAND + tv_usec);
}

void msdelay(int msec)
{
    osal_timeval pre_time = { 0 };
    osal_timeval cur_time = { 0 };
    osal_gettimeofday(&pre_time);
    unsigned long pre_us = M_TIME_TO_USEC(pre_time.tv_sec, pre_time.tv_usec);
    while (1) {
        osal_gettimeofday(&cur_time);
        if (M_TIME_TO_USEC(cur_time.tv_sec, cur_time.tv_usec) - pre_us > msec * THOUSAND) {
            break;
        }
    }
}

static void sle_sample_init_data(uint8_t *data)
{
    printf("[ssap client] init data\r\n");
    for (int i = 0; i <= SLE_DATA_SIZE_DEFAULT; i++) {
        data[i] = i; // 这里仅为示例，将所有元素初始化为它们的索引值
    }
}

static void sle_sample_send_data(uint8_t *data, uint16_t data_len)
{
    ssapc_write_param_t sle_send_param = {0};
    sle_send_param.handle = g_handle;
    sle_send_param.type = SSAP_PROPERTY_TYPE_VALUE;
    sle_send_param.data_len = data_len;
    sle_send_param.data = data;

    if (gle_tx_acb_data_num_get() > 0) {
        msdelay(1);
        ssapc_write_cmd(g_client_id, g_connect_id, &sle_send_param);
    } else {
        msdelay(1);
    }
}

void sle_client_send_hb(void)
{
    ssapc_write_param_t p = {0};
    static uint8_t hb = 0x01;
    uint8_t k;
    p.type = SSAP_PROPERTY_TYPE_VALUE;
    p.data_len = 1;
    p.data = &hb;
    {
        static uint8_t rssi_tick = 0;
        if (++rssi_tick >= 5) {
            rssi_tick = 0;
            for (k = 0; k < 16; k++) {
                if (g_conn_live[k]) {
                    (void)sle_read_remote_device_rssi(k);
                }
            }
        }
    }
    for (k = 0; k < 16; k++) {
        if (g_conn_live[k] == 0) {
            if (g_conn_hold[k]) {
                g_hold_age[k]++;
                if (g_hold_age[k] > 4) {
                    g_conn_hold[k] = 0;
                    g_hold_age[k] = 0;
                    memset_s(&g_conn_addr[k], sizeof(sle_addr_t), 0, sizeof(sle_addr_t));
                    printf("[ssap client] slot %d connect timeout, release\r\n", k);
                }
            }
            continue;
        }
        g_hold_age[k] = 0;
        if (g_handle_tbl[k] == 0) {
            continue;
        }
        p.handle = g_handle_tbl[k];
        (void)ssapc_write_cmd(g_client_id, k, &p);
    }
}

static void *sle_send_thread(uint8_t *arg)
{
    uint8_t data[SLE_DATA_SIZE_DEFAULT] = {0};
    sle_sample_init_data(data);

    while (1) {
        // 0还未初始化完成，等待
        if (g_send_flag == SEND_STATE_IDLE) {
            usleep(MS_100);
            continue;
        }
        // 2退出
        if (g_send_flag == SEND_STATE_EXIT) {
            break;
        }
        sle_sample_send_data(data, SLE_DATA_SIZE_DEFAULT);
    }
    return NULL;
}

int sle_send_thread_init()
{
    int ret = pthread_create(&g_send_thread, NULL, sle_send_thread, NULL);
    if (ret < 0) {
        printf("Err: fail to create write thread.\n");
        return -1;
    }
    printf("sle_comm_init.\n");
    return 0;
}

void sle_send_thread_deinit()
{
    g_send_flag = SEND_STATE_EXIT;
    pthread_join(g_send_thread, NULL);
}

void sle_sample_send_thread_reset()
{
    g_send_flag = SEND_STATE_IDLE;
}

static errcode_t sle_sample_register_persistence_info()
{
    char buff[BYTE_LEN_128] = {0};
    char *path = getcwd(buff, BYTE_LEN_128);
    printf("%s current path: %s", __func__, buff);
    return sle_dev_manager_register_file_path(buff);
}

void sle_client_init()
{
    sle_sample_seek_cbk_register();
    sle_sample_connect_cbk_register();
    sle_sample_ssapc_cbk_register();
    sle_announce_seek_register_callbacks(&g_seek_cbk);
    sle_connection_register_callbacks(&g_connect_cbk);
    ssapc_register_callbacks(&g_ssapc_cbk);
    errcode_t ret = sle_sample_register_persistence_info();
    if (ret != ERRCODE_SLE_SUCCESS) {
        printf("%s reg persistence_info failed, errcode: %d\n", __func__, ret);
    }
    enable_sle();
    sle_send_thread_init();
    return;
}

void sle_client_deinit()
{
    sle_send_thread_deinit();
    errcode_t ret = ERRCODE_SLE_SUCCESS;
    sle_stop_seek();
    ret |= ssapc_unregister_client(g_client_id);  // 去注册
    if (ret != ERRCODE_SLE_SUCCESS) {
        printf("ssapc_unregister_client failed, errorcode: %0x\r\n", ret);
        return ERRCODE_SLE_FAIL;
    }
    ret |= disable_sle();
    if (ret != ERRCODE_SLE_SUCCESS) {
        printf("disable_sle failed, errorcode: %0x\r\n", ret);
        return ERRCODE_SLE_FAIL;
    }
    return ret;
}