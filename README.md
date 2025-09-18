# PDai Analytics Package

[![R Package](https://img.shields.io/badge/R-Package-blue)](https://www.r-project.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

PDai (Predictive Data Analytics Intelligence) is a comprehensive R package designed for AI-powered predictive analytics and data insights. It provides core functionality for statistical modeling, machine learning workflows, and advanced data analysis tasks.

## Features

- **Predictive Modeling**: Advanced algorithms for regression, classification, and time series forecasting
- **Data Processing**: Efficient data manipulation and transformation utilities
- **Statistical Analysis**: Comprehensive statistical testing and inference tools
- **Visualization**: Built-in plotting functions for data exploration and model diagnostics
- **AI Integration**: Seamless integration with modern AI/ML frameworks

## Installation

### From GitHub

```r
# Install devtools if not already installed
if (!require(devtools)) {
  install.packages("devtools")
}

# Install PDai from GitHub
devtools::install_github("embeddedlayers/package-PDai")
```

### Development Version

```r
# Clone the repository
git clone https://github.com/embeddedlayers/package-PDai.git

# Install from local directory
devtools::install("package-PDai")
```

## Quick Start

```r
# Load the package
library(PDai)

# Example: Basic predictive analysis
data <- load_sample_data()
model <- pdai_predict(data, target = "outcome")
summary(model)

# Generate insights
insights <- generate_insights(model)
print(insights)
```

## Main Functions

- `pdai_predict()`: Automated predictive modeling with best model selection
- `pdai_classify()`: Classification tasks with multiple algorithm options
- `pdai_cluster()`: Unsupervised clustering analysis
- `pdai_timeseries()`: Time series analysis and forecasting
- `generate_insights()`: AI-powered insights generation
- `validate_model()`: Comprehensive model validation and diagnostics

## Documentation

Detailed documentation for each function is available through R's help system:

```r
?pdai_predict
?generate_insights
```

## Requirements

- R (>= 4.0.0)
- Dependencies are automatically installed with the package

## Database Integration

For PostgreSQL integration and enterprise features, see our companion package [PDaiPostgres](https://github.com/embeddedlayers/package-PDaiPostgres).

## Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details on how to submit pull requests, report issues, and contribute to documentation.

## Support

- **Issues**: [GitHub Issues](https://github.com/embeddedlayers/package-PDai/issues)
- **Email**: support@embeddedlayers.com
- **Documentation**: [Package Documentation](https://github.com/embeddedlayers/package-PDai/wiki)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Citation

If you use PDai in your research, please cite:

```
@software{pdai2024,
  title = {PDai: AI-Powered Predictive Analytics for R},
  author = {PeopleDrivenAI LLC},
  year = {2024},
  url = {https://github.com/embeddedlayers/package-PDai}
}
```

## Related Projects

- [MCP Analytics](https://github.com/embeddedlayers/mcp-analytics): Professional statistical analysis tools for Claude/Cursor
- [PDaiPostgres](https://github.com/embeddedlayers/package-PDaiPostgres): PostgreSQL integration for PDai

---

<div align="center">
  <strong>Part of the EmbeddedLayers Analytics Ecosystem</strong>
</div>
