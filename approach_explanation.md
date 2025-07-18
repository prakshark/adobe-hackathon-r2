# Approach Explanation for Round 1B: PDF Semantic Section Extraction and Ranking

## Overview
This solution processes multiple PDFs to extract, chunk, and semantically rank document sections based on a user persona and job description. The pipeline is designed for offline, CPU-only execution in a Docker container, with all models pre-downloaded during the build phase.

## PDF Preprocessing and Chunking
We use PyMuPDF to extract text from each PDF, preserving page numbers and document references. The text is chunked by paragraph or heading, ensuring that each chunk is contextually meaningful. Each chunk retains metadata: document name, page number, and (if available) section title. This structure supports downstream semantic search and ranking.

## Embedding and Semantic Matching
The persona and job description are concatenated into a single query string. We use a pre-downloaded SentenceTransformer model (e.g., all-MiniLM-L6-v2) to embed both the query and all document chunks into a shared vector space. This enables efficient semantic similarity computation.

## Indexing and Ranking
All chunk embeddings are indexed using FAISS, a high-performance similarity search library. The persona/job query embedding is compared to all chunk embeddings using cosine similarity. The top-ranked chunks are selected as the most relevant sections for the persona/job context.

## Output Formatting
The output JSON includes:
- Metadata: input document names, persona, job, and timestamp
- Sections: top-matching chunks with document name, page, section title, and importance rank
- Subsection analysis: the refined text of each top chunk

## Offline and Performance Considerations
All dependencies and models are installed and downloaded during the Docker build. No internet access is required at runtime. The solution is optimized for ≤60 seconds runtime on 3–5 PDFs, with a model size under 1GB and CPU-only execution.

## Extensibility
The modular codebase (with separate files for parsing, matching, and utilities) allows for easy extension, such as adding summarization with transformers or more advanced chunking/grouping logic. 