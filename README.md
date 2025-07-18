# PDF Outline Extractor (Round 1A)

Extracts structured outlines (title, H1, H2, H3) from PDFs (max 50 pages), outputs as JSON, and runs fully offline in Docker.

## Features
- Extracts title and heading structure using font size and layout
- Outputs JSON with title and outline
- Runs offline, CPU-only, <200MB model, <10s per file

## Usage

### 1. Build Docker Image
```sh
docker build -t pdf-outline-extractor .
```

### 2. Prepare Input/Output Folders
- Place PDFs to process in a folder, e.g. `input/`
- Create an empty `output/` folder

### 3. Run the Container
```sh
docker run --rm -v $(pwd)/input:/app/input -v $(pwd)/output:/app/output pdf-outline-extractor
```
- Output JSONs will appear in `output/`

## JSON Output Format
```json
{
  "title": "Document Title",
  "outline": [
    { "level": "H1", "text": "Heading One", "page": 1 },
    { "level": "H2", "text": "Subheading", "page": 2 }
  ]
}
```

## Tech Stack
- Python 3.10 (slim)
- pdfminer.six
- scikit-learn
- numpy

## Notes
- No internet required at runtime
- No GPU required
- Handles up to 50-page PDFs 