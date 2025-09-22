# Data Directory

This directory is for storing data files used by your project.

## Structure

Organize your data files according to your project's needs:

```
data/
├── raw/              # Raw, unprocessed data
├── processed/        # Cleaned and processed data
├── external/         # Data from external sources
├── interim/          # Intermediate data during processing
├── fixtures/         # Test data and fixtures
└── README.md         # This file
```

## Guidelines

### Data Management
- Keep raw data immutable
- Version control small data files only
- Use `.gitignore` for large data files
- Document data sources and formats
- Include data validation scripts

### Security
- Never commit sensitive data
- Use environment variables for data paths
- Encrypt sensitive data at rest
- Follow data privacy regulations

### Large Files
For large data files, consider:
- Git LFS (Large File Storage)
- External storage services (AWS S3, Google Cloud)
- Data version control tools (DVC)
- Database storage for structured data

## Data Types

### Sample Data (fixtures/)
Small datasets for testing and examples:
- JSON configuration files
- CSV sample data
- Test images or documents
- Mock API responses

### External Data (external/)
Data from external sources:
- API downloads
- Third-party datasets
- Partner data feeds
- Reference data

### Processed Data (processed/)
Cleaned and processed datasets:
- Normalized data
- Feature-engineered datasets
- Aggregated summaries
- Model-ready data

## Example .gitignore Patterns

Add to your `.gitignore`:
```
# Large data files
data/raw/*.csv
data/raw/*.xlsx
data/raw/*.json
data/processed/*.parquet
data/external/*.zip

# Keep structure but ignore contents
data/*/
!data/*/README.md
!data/fixtures/
```

## Data Access Patterns

### Python Example
```python
import os
from pathlib import Path

# Data directory paths
DATA_DIR = Path(__file__).parent / "data"
RAW_DATA_DIR = DATA_DIR / "raw"
PROCESSED_DATA_DIR = DATA_DIR / "processed"

def load_data(filename):
    """Load data from the appropriate directory."""
    return pd.read_csv(RAW_DATA_DIR / filename)
```

### Environment Variables
```bash
# .env
DATA_ROOT=/path/to/data
RAW_DATA_PATH=${DATA_ROOT}/raw
PROCESSED_DATA_PATH=${DATA_ROOT}/processed
```

## Data Validation

Create validation scripts:
```python
def validate_data(df):
    """Validate data quality."""
    assert not df.empty, "Data is empty"
    assert df.isnull().sum().sum() == 0, "Data contains null values"
    return True
```

## Documentation

Document your data:
- Source and collection method
- Data dictionary/schema
- Known issues or limitations
- Processing steps applied
- Update frequency