# ComfyUI RunPod Worker - Furniture Compositing

A custom ComfyUI serverless worker for furniture product photography and compositing.

## Features

### Models Included
- **RealVisXL V4.0** - Photoreal SDXL checkpoint (~6.5GB)
- **IP-Adapter Plus SDXL** - Product identity preservation (~2.5GB)
- **CLIP-ViT-H-14** - Vision encoder for IP-Adapter (~3.9GB)
- **ControlNet Depth SDXL** - Scene structure control (~2.5GB)
- **4x UltraSharp** - High-quality upscaler (~67MB)
- **SDXL VAE** - Better image quality (~335MB)

### Custom Nodes Included
- `ComfyUI_IPAdapter_plus` - IP-Adapter for product compositing
- `ComfyUI_Nano_Banana` - **Nano Banana Pro** (Gemini 3 Pro Image) for multi-reference product placement
- `comfyui_controlnet_aux` - Depth/Canny/Line preprocessors
- `ComfyUI_essentials` - Image transforms and masks
- `ComfyUI-Impact-Pack` - Advanced masking/segmentation
- `ComfyUI-Custom-Scripts` - Useful utilities
- `was-node-suite-comfyui` - Additional image processing

## Deploy to RunPod

### Option 1: Deploy from GitHub (Recommended)

1. Go to [RunPod Serverless](https://runpod.io/console/serverless)
2. Click **"+ New Endpoint"**
3. Select **"Custom Source"** → **"Build from GitHub"**
4. Enter your GitHub repo URL
5. Configure:
   - **GPU**: RTX 4090 or A6000 (24GB VRAM minimum)
   - **Active Workers**: 0
   - **Max Workers**: 2-3
   - **Idle Timeout**: 5 seconds
6. Click **Create**

Build time: ~15-20 minutes (downloading models)

### Option 2: Use Pre-built Docker Image

If you've pushed to Docker Hub:

```
your-dockerhub-username/comfyui-furniture:latest
```

## GPU Requirements

| GPU | VRAM | Status |
|-----|------|--------|
| RTX 3090 | 24GB | ✅ Works |
| RTX 4090 | 24GB | ✅ Recommended |
| A5000 | 24GB | ✅ Works |
| A6000 | 48GB | ✅ Best |
| A100 | 40/80GB | ✅ Best |

**Minimum VRAM**: 20GB (SDXL + IP-Adapter requires ~16GB)

## API Usage

### Generate Scene (Synchronous)

```bash
curl -X POST \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"input":{"workflow": YOUR_WORKFLOW_JSON }}' \
  https://api.runpod.ai/v2/YOUR_ENDPOINT_ID/runsync
```

### With Product Image Input

```bash
curl -X POST \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "input": {
      "workflow": YOUR_WORKFLOW_JSON,
      "images": [
        {
          "name": "product.png",
          "image": "BASE64_ENCODED_IMAGE"
        }
      ]
    }
  }' \
  https://api.runpod.ai/v2/YOUR_ENDPOINT_ID/runsync
```

## Available Models (for workflows)

Use these exact names in your ComfyUI workflows:

| Type | Filename |
|------|----------|
| Checkpoint | `RealVisXL_V4.0.safetensors` |
| IP-Adapter | `ip-adapter-plus_sdxl_vit-h.safetensors` |
| CLIP Vision | `CLIP-ViT-H-14-laion2B-s32B-b79K.safetensors` |
| ControlNet | `diffusers_xl_depth_mid.safetensors` |
| Upscaler | `4x-UltraSharp.pth` |
| VAE | `sdxl_vae.safetensors` |

## Workflows

See the `workflows/` folder for ready-to-use workflow JSONs:

| Workflow | Description | Technology |
|----------|-------------|------------|
| `wf-01-product-to-scene.json` | Single product compositing | IP-Adapter + SDXL |
| `wf-02-multi-product-set.json` | Multiple products in scene | IP-Adapter + SDXL |
| `wf-03-offer-moodboard.json` | Sales moodboard generation | IP-Adapter + SDXL |
| `wf-04-nano-banana-product.json` | Multi-reference product placement | **Nano Banana Pro** |

See [NANO_BANANA_GUIDE.md](./NANO_BANANA_GUIDE.md) for detailed Nano Banana Pro setup.

## Environment Variables

Set these in your RunPod endpoint configuration:

| Variable | Required For | Description |
|----------|--------------|-------------|
| `GOOGLE_API_KEY` | wf-04 | Google AI API key for Nano Banana Pro |

Get your API key from [Google AI Studio](https://aistudio.google.com/app/apikey).

## Local Development

```bash
# Build locally
docker build -t comfyui-furniture .

# Run locally (requires NVIDIA GPU)
docker run --gpus all -p 8188:8188 comfyui-furniture
```

## Estimated Costs

- **Cold start**: ~30-60 seconds
- **Generation time**: ~15-30 seconds per image
- **Cost per image**: ~$0.01-0.02 (RTX 4090)

## License

MIT License - Use freely for commercial purposes.
