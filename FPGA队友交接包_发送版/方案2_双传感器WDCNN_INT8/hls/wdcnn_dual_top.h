#pragma once
#include <cstdint>

extern "C" void wdcnn_dual_top(
    const int8_t* vibration_input, const int8_t* current_input,
    const int8_t* vibration_weights, const int32_t* vibration_biases,
    const int32_t* vibration_multipliers, const int32_t* vibration_shifts,
    const int8_t* current_weights, const int32_t* current_biases,
    const int32_t* current_multipliers, const int32_t* current_shifts,
    int8_t* vibration_logits, int8_t* current_logits, bool reload_weights);
