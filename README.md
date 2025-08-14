# tongue_tied

[![Package Version](https://img.shields.io/hexpm/v/tongue_tied)](https://hex.pm/packages/tongue_tied)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/tongue_tied/)

A robust BCP47 language tag parser for Gleam. Parse and validate language tags according to RFC 5646 (BCP47) specification.

The test suite was copied from https://github.com/wooorm/bcp-47 (MIT licensed)

```sh
gleam add tongue_tied
```

## Usage

```gleam
import tongue_tied

pub fn main() -> Nil {
  // Parse a simple language tag
  let assert Ok(tag) = tongue_tied.parse_language_tag("en-US")
  // Returns: LangTag(language: "en", script: None, region: Some("us"), variants: [], extensions: [], privateuse: None)

  // Parse a complex language tag with script and variants
  let assert Ok(complex) = tongue_tied.parse_language_tag("zh-Hant-HK")
  // Returns: LangTag(language: "zh", script: Some("hant"), region: Some("hk"), variants: [], extensions: [], privateuse: None)

  // Parse grandfathered tags
  let assert Ok(grandfathered) = tongue_tied.parse_language_tag("i-klingon")
  // Returns: Grandfathered("i-klingon")

  // Parse private use tags
  let assert Ok(private) = tongue_tied.parse_language_tag("x-custom-lang")
  // Returns: PrivateUse("x-custom-lang")
}
```

## Features

- **Complete BCP47 Support**: Handles all language tag components including:
  - Primary language subtags (2-8 letters)
  - Extended language subtags
  - Script codes (4 letters)
  - Region codes (2 letters or 3 digits)
  - Variant subtags
  - Extension subtags
  - Private use subtags

- **Grandfathered Tags**: Full support for both regular and irregular grandfathered tags like `i-klingon`, `en-GB-oed`, `zh-min-nan`

- **Private Use Tags**: Handles private use language tags starting with `x-`

- **Case Normalization**: Automatically normalizes case according to BCP47 conventions (lowercase language/region, title-case script)

- **Robust Parsing**: Comprehensive error handling and validation

## Language Tag Components

The parser returns different types based on the tag structure:

### `LangTag`

For well-formed language tags:

```gleam
LangTag(
  language: String,     // Required: "en", "zh-cmn", etc.
  script: Option(String),   // Optional: "Latn", "Hant", etc.
  region: Option(String),   // Optional: "US", "419", etc.
  variants: List(String),   // Optional: ["1901", "arevela"]
  extensions: List(Extension), // Optional: Unicode/other extensions
  privateuse: Option(String)   // Optional: private use subtags
)
```

### `Grandfathered`

For grandfathered tags:

```gleam
Grandfathered(String) // "i-klingon", "en-GB-oed", etc.
```

### `PrivateUse`

For private use tags:

```gleam
PrivateUse(String) // "x-whatever", "x-custom-123"
```

## Examples

### Basic Language Tags

```gleam
// Simple language
tongue_tied.parse_language_tag("en") 
// -> Ok(LangTag(language: "en", ...))

// Language with region
tongue_tied.parse_language_tag("fr-CA")
// -> Ok(LangTag(language: "fr", region: Some("ca"), ...))

// Language with script
tongue_tied.parse_language_tag("zh-Hant")
// -> Ok(LangTag(language: "zh", script: Some("hant"), ...))
```

### Extended Language Subtags

```gleam
// Chinese with Mandarin variant
tongue_tied.parse_language_tag("zh-cmn-Hans-CN")
// -> Ok(LangTag(language: "zh-cmn", script: Some("hans"), region: Some("cn"), ...))
```

### Variants and Extensions

```gleam
// German with historical variant
tongue_tied.parse_language_tag("de-CH-1901")
// -> Ok(LangTag(language: "de", region: Some("ch"), variants: ["1901"], ...))

// English with Unicode extension
tongue_tied.parse_language_tag("en-US-u-islamcal")
// -> Ok(LangTag(language: "en", region: Some("us"), extensions: [Extension(singleton: "u", subtags: ["islamcal"])], ...))
```

### Grandfathered and Private Use

```gleam
// Irregular grandfathered tag
tongue_tied.parse_language_tag("i-navajo")
// -> Ok(Grandfathered("i-navajo"))

// Private use tag
tongue_tied.parse_language_tag("x-my-custom-language")
// -> Ok(PrivateUse("x-my-custom-language"))
```

Further documentation can be found at <https://hexdocs.pm/tongue_tied>.

## Development

```sh
gleam run                      # Run the project
gleam test --target erlang     # Run the tests
gleam test --target javascript # Run the tests
```
