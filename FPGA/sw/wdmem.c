// wdmem.c -- reserve a contiguous physical buffer for PL DMA and map it uncached
// build: make -C /lib/modules/$(uname -r)/build M=$PWD modules
#include <linux/module.h>
#include <linux/fs.h>
#include <linux/mm.h>
#include <linux/gfp.h>
#include <linux/device.h>
#include <linux/cdev.h>
#include <linux/io.h>
#include <linux/version.h>

#define WD_ORDER 10                       /* 4 MiB */
#define WD_SIZE  (PAGE_SIZE << WD_ORDER)

static struct page *wd_page;
static unsigned long wd_phys;
static int wd_major;
static struct class *wd_class;
static struct device *wd_dev;

static int wd_open(struct inode *i, struct file *f) { return 0; }
static int wd_release(struct inode *i, struct file *f) { return 0; }

static int wd_mmap(struct file *f, struct vm_area_struct *vma)
{
    unsigned long len = vma->vm_end - vma->vm_start;

    if (len > WD_SIZE)
        return -EINVAL;
    vma->vm_pgoff = 0;
    return remap_pfn_range(vma, vma->vm_start, wd_phys >> PAGE_SHIFT, len,
                   pgprot_writecombine(vma->vm_page_prot));
}

static const struct file_operations wd_fops = {
    .owner = THIS_MODULE,
    .open = wd_open,
    .release = wd_release,
    .mmap = wd_mmap,
};

static ssize_t phys_show(struct device *d, struct device_attribute *a, char *buf)
{
    return sprintf(buf, "0x%lx\n", wd_phys);
}
static DEVICE_ATTR_RO(phys);

static ssize_t size_show(struct device *d, struct device_attribute *a, char *buf)
{
    return sprintf(buf, "%lu\n", (unsigned long)WD_SIZE);
}
static DEVICE_ATTR_RO(size);

static int __init wd_init(void)
{
    wd_page = alloc_pages(GFP_KERNEL | GFP_DMA32 | __GFP_ZERO, WD_ORDER);
    if (wd_page == NULL)
        return -ENOMEM;

    wd_phys = page_to_phys(wd_page);

    wd_major = register_chrdev(0, "wdmem", &wd_fops);
    if (wd_major < 0)
        return wd_major;

#if LINUX_VERSION_CODE >= KERNEL_VERSION(6, 4, 0)
    wd_class = class_create("wdmem");
#else
    wd_class = class_create(THIS_MODULE, "wdmem");
#endif
    if (IS_ERR(wd_class))
        return PTR_ERR(wd_class);

    wd_dev = device_create(wd_class, NULL, MKDEV(wd_major, 0), NULL, "wdmem");
    if (IS_ERR(wd_dev))
        return PTR_ERR(wd_dev);

    device_create_file(wd_dev, &dev_attr_phys);
    device_create_file(wd_dev, &dev_attr_size);

    pr_info("wdmem: phys=0x%lx size=%lu\n", wd_phys, (unsigned long)WD_SIZE);
    return 0;
}

static void __exit wd_exit(void)
{
    device_destroy(wd_class, MKDEV(wd_major, 0));
    class_destroy(wd_class);
    unregister_chrdev(wd_major, "wdmem");
    if (wd_page)
        __free_pages(wd_page, WD_ORDER);
    pr_info("wdmem: unloaded\n");
}

module_init(wd_init);
module_exit(wd_exit);
MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("contiguous PL buffer for KV260 WDCNN");
