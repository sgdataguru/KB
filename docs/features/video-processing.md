# Video Processing Feature

## Overview

The Video Processing pipeline automatically extracts transcripts from training videos and Teams recordings, enabling semantic search with precise timestamp navigation.

## User Stories

### US-010: Automatic Transcription
**As a** content manager  
**I want** videos to be automatically transcribed  
**So that** the content becomes searchable

### US-011: Timestamp Linking
**As a** junior staff member  
**I want** to jump directly to relevant video sections  
**So that** I don't waste time watching entire videos

## Technical Implementation

### Processing Pipeline

```
Video Upload
     │
     ▼
┌─────────────────┐
│  Extract Audio  │ ◄── FFmpeg or Azure Media Services
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Azure Speech    │ ◄── Speech-to-Text API
│ Services        │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Timestamp       │ ◄── Word-level timestamps
│ Extraction      │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Text Chunking   │ ◄── Semantic chunking with overlap
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Generate        │ ◄── Azure OpenAI Embeddings
│ Embeddings      │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Index in        │ ◄── Store vectors + metadata
│ AI Search       │
└─────────────────┘
```

### Supported Formats

| Format | Extension | Source |
|--------|-----------|--------|
| MP4 | .mp4 | SharePoint, Teams |
| WebM | .webm | Teams Recordings |
| WAV | .wav | Audio-only |
| M4A | .m4a | Audio-only |

## Azure Function Implementation

### Trigger: SharePoint File Upload

```python
import azure.functions as func
from azure.cognitiveservices.speech import SpeechConfig, AudioConfig, SpeechRecognizer

async def process_video(blob: func.InputStream):
    # 1. Download video to temp storage
    video_path = download_to_temp(blob)
    
    # 2. Extract audio
    audio_path = extract_audio(video_path)
    
    # 3. Transcribe with timestamps
    transcript = await transcribe_with_timestamps(audio_path)
    
    # 4. Chunk and embed
    chunks = chunk_transcript(transcript)
    embeddings = await generate_embeddings(chunks)
    
    # 5. Index in AI Search
    await index_chunks(chunks, embeddings, metadata={
        "source": blob.name,
        "type": "video",
        "duration": get_duration(video_path)
    })
```

### Transcription with Timestamps

```python
def transcribe_with_timestamps(audio_path: str) -> list[dict]:
    speech_config = SpeechConfig(
        subscription=os.getenv("SPEECH_KEY"),
        region="eastasia"
    )
    speech_config.request_word_level_timestamps()
    
    audio_config = AudioConfig(filename=audio_path)
    recognizer = SpeechRecognizer(speech_config, audio_config)
    
    results = []
    def handle_result(evt):
        result = evt.result
        words = result.json.get("NBest", [{}])[0].get("Words", [])
        results.append({
            "text": result.text,
            "start_time": words[0]["Offset"] / 10_000_000 if words else 0,
            "end_time": (words[-1]["Offset"] + words[-1]["Duration"]) / 10_000_000 if words else 0
        })
    
    recognizer.recognized.connect(handle_result)
    recognizer.start_continuous_recognition()
    
    return results
```

## Chunking Strategy

### Parameters
| Parameter | Value | Rationale |
|-----------|-------|-----------|
| Chunk Size | 500 tokens | Optimal for embedding model |
| Overlap | 100 tokens | Maintain context at boundaries |
| Min Chunk | 50 tokens | Avoid tiny chunks |

### Timestamp Preservation
Each chunk includes:
- Start timestamp (seconds)
- End timestamp (seconds)
- Source video URL
- Thumbnail URL (if available)

## Metadata Schema

```json
{
  "id": "video-123-chunk-5",
  "content": "...transcript text...",
  "content_vector": [...],
  "source_type": "video",
  "source_url": "sharepoint://videos/training/k2-calibration.mp4",
  "video_title": "K2 Calibration Training",
  "start_timestamp": 930,
  "end_timestamp": 980,
  "duration": 50,
  "total_duration": 3600,
  "department": "technical",
  "version": 1,
  "processed_at": "2026-01-14T12:00:00Z"
}
```

## Teams Recording Integration

1. **Graph API Subscription** - Listen for new meeting recordings
2. **Download Recording** - Fetch from OneDrive/SharePoint
3. **Extract Metadata** - Meeting title, participants, date
4. **Process as Video** - Same pipeline as uploaded videos

## Error Handling

| Error | Action |
|-------|--------|
| Audio extraction fails | Retry with different codec |
| Transcription timeout | Split into smaller segments |
| Poor audio quality | Flag for manual review |
| Unsupported format | Convert with FFmpeg |

## Performance

| Metric | Target |
|--------|--------|
| 1-hour video processing | < 15 minutes |
| Transcription accuracy | > 90% WER |
| Chunk indexing | < 2 seconds per chunk |