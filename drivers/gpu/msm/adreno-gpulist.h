/* SPDX-License-Identifier: GPL-2.0-only */
/*
 * Copyright (c) 2002,2007-2020, The Linux Foundation. All rights reserved.
 */

#define ANY_ID (~0)

#define DEFINE_ADRENO_REV(_rev, _core, _major, _minor, _patchid) \
	.gpurev = _rev, .core = _core, .major = _major, .minor = _minor, \
	.patchid = _patchid

#define DEFINE_DEPRECATED_CORE(_name, _rev, _core, _major, _minor, _patchid) \
static const struct adreno_gpu_core adreno_gpu_core_##_name = { \
	DEFINE_ADRENO_REV(_rev, _core, _major, _minor, _patchid), \
	.features = ADRENO_DEPRECATED, \
}


/* This apply to a610 */
static const struct adreno_a6xx_core adreno_gpu_core_a610 = {
	.base = {
		DEFINE_ADRENO_REV(ADRENO_REV_A610, 6, 1, 0, ANY_ID),
		.features = ADRENO_64BIT | ADRENO_CONTENT_PROTECTION |
			ADRENO_PREEMPTION,
		.gpudev = &adreno_a6xx_gpudev,
		.gmem_size = (SZ_128K + SZ_4K),
		.busy_mask = 0xfffffffe,
		.bus_width = 32,
	},
	.prim_fifo_threshold = 0x00080000,
	.sqefw_name = "a630_sqe.fw",
	.zap_name = "a610_zap",
	.hwcg = a612_hwcg_regs,
	.hwcg_count = ARRAY_SIZE(a612_hwcg_regs),
	.vbif = a640_vbif_regs,
	.vbif_count = ARRAY_SIZE(a640_vbif_regs),
	.hang_detect_cycles = 0x3ffff,
	.protected_regs = a630_protected_regs,
};

static const struct adreno_gpu_core *adreno_gpulist[] = {
	&adreno_gpu_core_a610.base,
};
