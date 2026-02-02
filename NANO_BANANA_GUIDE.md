# Nano Banana Pro - Multi-Reference Product Placement

Nano Banana Pro (Google Gemini 3 Pro Image) enables high-fidelity product placement with support for **up to 6 reference images**. This gives significantly better product identity preservation compared to IP-Adapter.

## Why Nano Banana Pro?

| Feature | IP-Adapter | Nano Banana Pro |
|---------|------------|-----------------|
| Reference images | 1-2 (batch averaging) | **Up to 6 native** |
| Identity preservation | Style-focused | **Object-focused** |
| Resolution | 1024x1024 (SDXL) | **Up to 4K (4096x4096)** |
| Multi-angle understanding | Weak | **Strong** |
| Text rendering | Poor | **Excellent** |
| Cost per image | ~$0.02 (GPU time) | ~$0.13 (2K) / $0.24 (4K) |

**Best for**: When you need the generated product to look exactly like your reference images, especially with multiple angles.

---

## Setup

### 1. Get a Google AI API Key

1. Go to [Google AI Studio](https://aistudio.google.com/app/apikey)
2. Sign in with your Google account
3. Click **"Create API Key"**
4. Copy the key

### 2. Add to RunPod Environment

1. Go to [RunPod Serverless Console](https://runpod.io/console/serverless)
2. Click on your endpoint → **"Edit Endpoint"** (or Manage → Edit)
3. Expand **"Environment variables"**
4. Add:
   - **Key**: `GOOGLE_API_KEY`
   - **Value**: `your-api-key-here`
5. Save changes

---

## Workflow: wf-04-nano-banana-product.json

### Inputs

| Input | Description |
|-------|-------------|
| `product_angle_1.png` | Front view of product |
| `product_angle_2.png` | Side view of product |
| `product_angle_3.png` | 3/4 angle view (optional but recommended) |

You can use up to 6 reference images (`image_1` through `image_6`).

### Parameters

| Parameter | Default | Options | Description |
|-----------|---------|---------|-------------|
| `model_name` | `gemini-3-pro-image-preview` | - | The Gemini model |
| `prompt` | - | Free text | Scene description |
| `image_count` | 1 | 1-10 | Number of variations |
| `use_search` | false | true/false | Ground in Google Search |
| `aspect_ratio` | 4:3 | 1:1, 16:9, 9:16, 4:3, 3:4, etc. | Output aspect ratio |
| `image_size` | 2K | 1K, 2K, 4K | Output resolution |
| `temperature` | 0.8 | 0.0-2.0 | Creativity (lower = more faithful) |

### Prompt Template

```
Place this [PRODUCT] in a [SCENE_TYPE]. [LIGHTING]. [ATMOSPHERE]. 
Professional [STYLE] photography, [LENS] perspective.
```

### Scene Examples

| Scene Type | Prompt Fragment |
|------------|-----------------|
| Modern Office | `modern Scandinavian workspace, natural daylight through large windows, light wood flooring, white walls, minimal clutter` |
| Executive Suite | `executive corner office with city view, warm afternoon light, dark wood furniture, leather accents, prestigious atmosphere` |
| Creative Studio | `creative studio with exposed brick walls, industrial loft, mixed materials, plants, artistic atmosphere` |
| Minimal Showroom | `minimal white showroom, gallery-like, museum-quality lighting, pure white environment, floating effect` |
| Home Office | `cozy home office, warm residential interior, bookshelves, soft natural light, comfortable atmosphere` |

---

## API Usage

### Basic Request

```bash
curl -X POST \
  -H "Authorization: Bearer YOUR_RUNPOD_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "input": {
      "workflow": <WF-04-JSON>,
      "images": [
        {"name": "product_angle_1.png", "image": "BASE64_FRONT_VIEW"},
        {"name": "product_angle_2.png", "image": "BASE64_SIDE_VIEW"},
        {"name": "product_angle_3.png", "image": "BASE64_34_VIEW"}
      ]
    }
  }' \
  https://api.runpod.ai/v2/YOUR_ENDPOINT_ID/runsync
```

### Dynamic Prompt Override

Modify the workflow JSON before sending to change the prompt:

```javascript
const workflow = require('./workflows/wf-04-nano-banana-product.json');
workflow["10"].inputs.prompt = "Place this ergonomic office chair in a modern tech startup office...";
workflow["10"].inputs.aspect_ratio = "16:9";
workflow["10"].inputs.image_size = "4K";
```

---

## Pricing

| Resolution | Cost per Image |
|------------|----------------|
| 1K (1024x1024) | ~$0.13 |
| 2K (2048x2048) | ~$0.13 |
| 4K (4096x4096) | ~$0.24 |

Costs are charged by Google, not RunPod. RunPod GPU costs are separate (~$0.01-0.02 per request for worker overhead).

---

## Tips for Best Results

### Reference Images

1. **Use transparent backgrounds** (PNG with alpha) when possible
2. **Include multiple angles**: front, side, 3/4 view minimum
3. **Consistent lighting**: similar lighting across reference images
4. **High resolution**: at least 1024px on the longest side

### Prompts

1. **Be specific about placement**: "positioned at a desk area", "in the center of the room"
2. **Describe lighting**: "natural daylight", "warm afternoon light", "soft diffused lighting"
3. **Mention perspective**: "85mm lens perspective", "eye-level view", "slightly elevated angle"
4. **Include atmosphere**: "minimal clutter", "professional atmosphere", "cozy and inviting"

### Temperature

- **0.5-0.7**: More faithful to references, less creative
- **0.8-1.0**: Balanced (recommended)
- **1.0-1.5**: More creative, may deviate from references

---

## Comparison: When to Use What

| Use Case | Recommended Workflow |
|----------|---------------------|
| Quick product mockups | wf-01 (IP-Adapter) |
| Multiple products in one scene | wf-02 (IP-Adapter) |
| Sales moodboards | wf-03 (IP-Adapter) |
| **Exact product identity matters** | **wf-04 (Nano Banana Pro)** |
| **Multiple product angles available** | **wf-04 (Nano Banana Pro)** |
| **High resolution needed (4K)** | **wf-04 (Nano Banana Pro)** |

---

## Troubleshooting

### "API key not found" or "Authentication failed"

- Verify `GOOGLE_API_KEY` is set in RunPod environment variables
- Check the key is valid at [AI Studio](https://aistudio.google.com/app/apikey)
- Rebuild the worker after adding the env var

### "Model overloaded" or 503 errors

- Google's API has rate limits during high demand
- Wait 30-60 seconds and retry
- Consider using a lower resolution (1K instead of 4K)

### Product doesn't look accurate

- Add more reference angles (use all 6 slots if available)
- Lower the temperature to 0.5-0.7
- Be more specific in the prompt about product details

### Output is wrong aspect ratio

- Verify `aspect_ratio` parameter matches your expected output
- Some prompts may override if they imply a specific format

---

## Resources

- [Nano Banana Pro Documentation](https://docs.comfy.org/tutorials/partner-nodes/google/nano-banana-pro)
- [ComfyUI_Nano_Banana GitHub](https://github.com/ru4ls/ComfyUI_Nano_Banana)
- [Google AI Studio](https://aistudio.google.com/app/apikey)
- [Gemini API Pricing](https://ai.google.dev/pricing)
