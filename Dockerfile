# ComfyUI RunPod Worker - Furniture Compositing Edition
# Includes: SDXL (RealVisXL), IP-Adapter, ControlNet, Upscaler
#
# Deploy to RunPod Serverless from this repo

FROM runpod/worker-comfyui:5.7.1-base

LABEL maintainer="Amoeba Works"
LABEL description="ComfyUI worker for furniture product compositing with IP-Adapter and SDXL"

# ============================================================================
# INSTALL CUSTOM NODES
# ============================================================================

WORKDIR /comfyui/custom_nodes

# IP-Adapter Plus - Critical for product identity preservation
RUN git clone --depth 1 https://github.com/cubiq/ComfyUI_IPAdapter_plus.git

# ControlNet Aux - Depth/Canny preprocessors
RUN git clone --depth 1 https://github.com/Fannovel16/comfyui_controlnet_aux.git

# Essentials - Image transforms, masks, utilities
RUN git clone --depth 1 https://github.com/cubiq/ComfyUI_essentials.git

# Impact Pack - Advanced masking and segmentation
RUN git clone --depth 1 https://github.com/ltdrdata/ComfyUI-Impact-Pack.git

# Custom Scripts - Useful node additions
RUN git clone --depth 1 https://github.com/pythongosssss/ComfyUI-Custom-Scripts.git

# WAS Node Suite - Additional image processing nodes
RUN git clone --depth 1 https://github.com/WASasquatch/was-node-suite-comfyui.git

# Nano Banana Pro - Google Gemini 3 Pro Image for multi-reference product placement
RUN git clone --depth 1 https://github.com/ru4ls/ComfyUI_Nano_Banana.git

# ============================================================================
# INSTALL NODE DEPENDENCIES
# ============================================================================

WORKDIR /comfyui

# Install Python dependencies for custom nodes
RUN pip install --no-cache-dir \
    insightface \
    onnxruntime \
    ftfy \
    timm \
    fairscale \
    transformers \
    accelerate

# ControlNet aux requirements
RUN cd /comfyui/custom_nodes/comfyui_controlnet_aux && \
    pip install --no-cache-dir -r requirements.txt || true

# Impact Pack requirements  
RUN cd /comfyui/custom_nodes/ComfyUI-Impact-Pack && \
    pip install --no-cache-dir -r requirements.txt || true

# WAS Node Suite requirements
RUN cd /comfyui/custom_nodes/was-node-suite-comfyui && \
    pip install --no-cache-dir -r requirements.txt || true

# Nano Banana Pro requirements (Google Generative AI SDK)
RUN cd /comfyui/custom_nodes/ComfyUI_Nano_Banana && \
    pip install --no-cache-dir -r requirements.txt || true

# ============================================================================
# DOWNLOAD MODELS
# ============================================================================

# --- SDXL Checkpoint: RealVisXL V4.0 (Photoreal) ---
RUN mkdir -p /comfyui/models/checkpoints && \
    wget -q --show-progress -O /comfyui/models/checkpoints/RealVisXL_V4.0.safetensors \
    "https://huggingface.co/SG161222/RealVisXL_V4.0/resolve/main/RealVisXL_V4.0.safetensors"

# --- IP-Adapter Models ---
RUN mkdir -p /comfyui/models/ipadapter && \
    wget -q --show-progress -O /comfyui/models/ipadapter/ip-adapter-plus_sdxl_vit-h.safetensors \
    "https://huggingface.co/h94/IP-Adapter/resolve/main/sdxl_models/ip-adapter-plus_sdxl_vit-h.safetensors"

# --- CLIP Vision Encoder (required for IP-Adapter) ---
RUN mkdir -p /comfyui/models/clip_vision && \
    wget -q --show-progress -O /comfyui/models/clip_vision/CLIP-ViT-H-14-laion2B-s32B-b79K.safetensors \
    "https://huggingface.co/h94/IP-Adapter/resolve/main/models/image_encoder/model.safetensors"

# --- ControlNet: Depth for SDXL ---
RUN mkdir -p /comfyui/models/controlnet && \
    wget -q --show-progress -O /comfyui/models/controlnet/diffusers_xl_depth_mid.safetensors \
    "https://huggingface.co/diffusers/controlnet-depth-sdxl-1.0-mid/resolve/main/diffusion_pytorch_model.fp16.safetensors"

# --- Upscaler: 4x UltraSharp ---
RUN mkdir -p /comfyui/models/upscale_models && \
    wget -q --show-progress -O /comfyui/models/upscale_models/4x-UltraSharp.pth \
    "https://huggingface.co/Kim2091/UltraSharp/resolve/main/4x-UltraSharp.pth"

# --- SDXL VAE (better quality) ---
RUN mkdir -p /comfyui/models/vae && \
    wget -q --show-progress -O /comfyui/models/vae/sdxl_vae.safetensors \
    "https://huggingface.co/stabilityai/sdxl-vae/resolve/main/sdxl_vae.safetensors"

# ============================================================================
# FINAL SETUP
# ============================================================================

# Set permissions
RUN chmod -R 755 /comfyui/models /comfyui/custom_nodes

# Return to worker directory
WORKDIR /

# The base image handles the CMD/ENTRYPOINT
