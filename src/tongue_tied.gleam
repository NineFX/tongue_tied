////
//// A BCP47 language tag parser for Gleam.
////
//// This module provides functionality to parse and validate language tags according to
//// RFC 5646 (BCP47) specification. It handles all types of language tags including
//// well-formed language tags, grandfathered tags, and private use tags.
////
//// ## Examples
////
//// ```gleam
//// import tongue_tied
////
//// // Parse a simple language tag
//// let assert Ok(tag) = tongue_tied.parse_language_tag("en-US")
//// // Returns: LangTag(language: "en", region: Some("us"), ...)
////
//// // Parse a complex tag with script
//// let assert Ok(complex) = tongue_tied.parse_language_tag("zh-Hant-HK")
//// // Returns: LangTag(language: "zh", script: Some("hant"), region: Some("hk"), ...)
////
//// // Parse grandfathered tags
//// let assert Ok(grandfathered) = tongue_tied.parse_language_tag("i-klingon")
//// // Returns: Grandfathered("i-klingon")
////
//// // Parse private use tags
//// let assert Ok(private) = tongue_tied.parse_language_tag("x-custom-lang")
//// // Returns: PrivateUse("x-custom-lang")
//// ```
////

import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string

/// Represents a parsed language tag according to BCP47 specification.
///
/// This type covers all possible language tag formats:
/// - `LangTag`: Well-formed language tags with optional components
/// - `PrivateUse`: Private use tags starting with "x-"
/// - `Grandfathered`: Special grandfathered tags preserved for compatibility
pub type LanguageTag {
  /// A well-formed language tag with its components.
  ///
  /// ## Fields
  /// - `language`: The primary language subtag, possibly including extended language subtags
  /// - `script`: Optional 4-letter script code (e.g., "Latn", "Hant")
  /// - `region`: Optional 2-letter or 3-digit region code (e.g., "US", "419")
  /// - `variants`: List of variant subtags
  /// - `extensions`: List of extension subtags with their singletons
  /// - `privateuse`: Optional private use subtags
  LangTag(
    language: String,
    script: Option(String),
    region: Option(String),
    variants: List(String),
    extensions: List(Extension),
    privateuse: Option(String),
  )
  /// A private use language tag starting with "x-".
  ///
  /// These tags are used for private agreements between parties.
  PrivateUse(privateuse: String)
  /// A grandfathered language tag.
  ///
  /// These are special tags that were registered before BCP47 and are
  /// maintained for backward compatibility (e.g., "i-klingon", "en-GB-oed").
  Grandfathered(tag: String)
}

/// Represents an extension in a language tag.
///
/// Extensions provide a mechanism for extending language tags with additional
/// information using single-character singletons.
pub type Extension {
  /// An extension with its singleton character and subtags.
  ///
  /// ## Fields
  /// - `singleton`: Single character identifier (except 'x')
  /// - `subtags`: List of 2-8 character alphanumeric subtags
  Extension(singleton: String, subtags: List(String))
}

/// Represents errors that can occur during language tag parsing.
pub type ParseError {
  /// Invalid format with descriptive message.
  InvalidFormat(message: String)
  /// Unexpected end of input.
  UnexpectedEnd
  /// Invalid character at specific position.
  InvalidCharacter(char: String, position: Int)
}

/// Parse a BCP47 language tag string into its structured representation.
///
/// This function accepts any valid BCP47 language tag and returns the appropriate
/// `LanguageTag` variant. The input is normalized to lowercase before parsing
/// (except for script codes which are title-cased in the output).
///
/// ## Examples
///
/// ```gleam
/// // Simple language
/// parse_language_tag("en")
/// // -> Ok(LangTag(language: "en", script: None, region: None, ...))
///
/// // Language with region
/// parse_language_tag("fr-CA")
/// // -> Ok(LangTag(language: "fr", region: Some("ca"), ...))
///
/// // Complex tag with script, region, and variant
/// parse_language_tag("de-Latn-DE-1901")
/// // -> Ok(LangTag(language: "de", script: Some("latn"), region: Some("de"), variants: ["1901"], ...))
///
/// // Grandfathered tag
/// parse_language_tag("i-klingon")
/// // -> Ok(Grandfathered("i-klingon"))
///
/// // Private use tag
/// parse_language_tag("x-my-language")
/// // -> Ok(PrivateUse("x-my-language"))
///
/// // Invalid tag
/// parse_language_tag("invalid-tag-123456789")
/// // -> Error(InvalidFormat("..."))
/// ```
pub fn parse_language_tag(input: String) -> Result(LanguageTag, ParseError) {
  let normalized = string.lowercase(input)
  let parts = string.split(normalized, "-")
  language_tag(parts)
}

/// Parse the main language tag structure.
///
/// This is the top-level parser that determines whether the input is a
/// grandfathered tag, private use tag, or regular language tag.
fn language_tag(parts: List(String)) -> Result(LanguageTag, ParseError) {
  let rejoined = string.join(parts, "-")

  // Try grandfathered first since they have specific patterns
  case grandfathered(rejoined) {
    Ok(tag) -> Ok(Grandfathered(tag))
    Error(_) ->
      case privateuse_tag(parts) {
        Ok(tag) -> Ok(PrivateUse(tag))
        Error(_) ->
          case langtag(parts) {
            Ok(tag) -> Ok(tag)
            Error(e) -> Error(e)
          }
      }
  }
}

/// Check if the input matches a known grandfathered tag.
///
/// Grandfathered tags are special tags that were registered before BCP47
/// and are maintained for backward compatibility. They include both irregular
/// and regular grandfathered tags.
fn grandfathered(input: String) -> Result(String, ParseError) {
  let all_grandfathered = [
    // irregular tags
    "en-gb-oed",
    "i-ami",
    "i-bnn",
    "i-default",
    "i-enochian",
    "i-hak",
    "i-klingon",
    "i-lux",
    "i-mingo",
    "i-navajo",
    "i-pwn",
    "i-tao",
    "i-tay",
    "i-tsu",
    "sgn-be-fr",
    "sgn-be-nl",
    "sgn-ch-de",
    // regular tags  
    "art-lojban",
    "cel-gaulish",
    "no-bok",
    "no-nyn",
    "zh-guoyu",
    "zh-hakka",
    "zh-min-nan",
    "zh-min",
    "zh-xiang",
  ]

  case list.find(all_grandfathered, fn(tag) { tag == input }) {
    Ok(tag) -> Ok(tag)
    Error(_) -> Error(InvalidFormat("Not a grandfathered tag"))
  }
}

/// Parse a private use tag starting with "x-".
///
/// Private use tags have the format: x-subtag1[-subtag2]...
/// where each subtag is 1-8 alphanumeric characters.
fn privateuse_tag(parts: List(String)) -> Result(String, ParseError) {
  case parts {
    ["x", ..subtags] -> {
      case
        list.all(subtags, fn(subtag) {
          string.length(subtag) >= 1
          && string.length(subtag) <= 8
          && is_all_alphanum(subtag)
        })
        && list.length(subtags) >= 1
      {
        True -> Ok(string.join(parts, "-"))
        False -> Error(InvalidFormat("Invalid private use subtags"))
      }
    }
    _ -> Error(InvalidFormat("Private use tag must start with 'x'"))
  }
}

/// Parse a well-formed language tag with its components.
///
/// Parses the tag according to the BCP47 grammar:
/// langtag = language ["-" script] ["-" region] *("-" variant) *("-" extension) ["-" privateuse]
fn langtag(parts: List(String)) -> Result(LanguageTag, ParseError) {
  case parts {
    [] -> Error(InvalidFormat("Empty language tag"))
    [first, ..rest] -> {
      use language <- result.try(parse_language_part(first, rest))
      let #(lang, remaining_after_lang) = language

      let #(script_opt, remaining_after_script) =
        parse_script(remaining_after_lang)
      let #(region_opt, remaining_after_region) =
        parse_region(remaining_after_script)
      let #(variants, remaining_after_variants) =
        parse_variants(remaining_after_region)
      let #(extensions, remaining_after_extensions) =
        parse_extensions(remaining_after_variants)
      let #(privateuse_opt, remaining_final) =
        parse_privateuse_in_langtag(remaining_after_extensions)

      case remaining_final {
        [] ->
          Ok(LangTag(
            language: lang,
            script: script_opt,
            region: region_opt,
            variants: variants,
            extensions: extensions,
            privateuse: privateuse_opt,
          ))
        _ ->
          Error(InvalidFormat(
            "Unexpected parts: " <> string.join(remaining_final, "-"),
          ))
      }
    }
  }
}

/// Parse the language component, including optional extended language subtags.
///
/// Language codes can be:
/// - 2-3 letters (with optional extended language subtags)
/// - 4 letters (reserved for future use)
/// - 5-8 letters (registered language subtags)
fn parse_language_part(
  first: String,
  rest: List(String),
) -> Result(#(String, List(String)), ParseError) {
  let first_len = string.length(first)

  case first_len >= 2 && first_len <= 3 && is_all_alpha(first) {
    True -> {
      // Check for optional extlang
      case parse_extlang(rest) {
        Ok(#(extlang, remaining)) -> Ok(#(first <> "-" <> extlang, remaining))
        Error(_) -> Ok(#(first, rest))
      }
    }
    False ->
      case first_len == 4 && is_all_alpha(first) {
        True -> Ok(#(first, rest))
        False ->
          case first_len >= 5 && first_len <= 8 && is_all_alpha(first) {
            True -> Ok(#(first, rest))
            False -> Error(InvalidFormat("Invalid language code: " <> first))
          }
      }
  }
}

/// Parse extended language subtags.
///
/// Extended language subtags are 3-letter codes that can follow 2-3 letter
/// primary language codes. Up to 3 extended language subtags are allowed.
fn parse_extlang(
  parts: List(String),
) -> Result(#(String, List(String)), ParseError) {
  case parts {
    [first, ..rest] ->
      case string.length(first) == 3 && is_all_alpha(first) {
        True -> {
          let #(additional, remaining) = parse_additional_extlang(rest, 0)
          case additional {
            [] -> Ok(#(first, remaining))
            _ -> Ok(#(first <> "-" <> string.join(additional, "-"), remaining))
          }
        }
        False -> Error(InvalidFormat("Invalid extlang"))
      }
    [] -> Error(InvalidFormat("No extlang"))
  }
}

/// Parse additional extended language subtags (up to 2 more after the first).
fn parse_additional_extlang(
  parts: List(String),
  count: Int,
) -> #(List(String), List(String)) {
  case count >= 2 {
    True -> #([], parts)
    False ->
      case parts {
        [part, ..rest] ->
          case string.length(part) == 3 && is_all_alpha(part) {
            True -> {
              let #(more, remaining) = parse_additional_extlang(rest, count + 1)
              #([part, ..more], remaining)
            }
            False -> #([], parts)
          }
        [] -> #([], parts)
      }
  }
}

/// Parse an optional script subtag.
///
/// Script subtags are 4-letter alphabetic codes (e.g., "Latn", "Cyrl", "Hant").
fn parse_script(parts: List(String)) -> #(Option(String), List(String)) {
  case parts {
    [part, ..rest] ->
      case string.length(part) == 4 && is_all_alpha(part) {
        True -> #(Some(part), rest)
        False -> #(None, parts)
      }
    [] -> #(None, parts)
  }
}

/// Parse an optional region subtag.
///
/// Region subtags can be:
/// - 2 letters (ISO 3166-1 country codes, e.g., "US", "GB")
/// - 3 digits (UN M.49 region codes, e.g., "001", "419")
fn parse_region(parts: List(String)) -> #(Option(String), List(String)) {
  case parts {
    [part, ..rest] -> {
      case
        { string.length(part) == 2 && is_all_alpha(part) }
        || { string.length(part) == 3 && is_all_digit(part) }
      {
        True -> #(Some(part), rest)
        False -> #(None, parts)
      }
    }
    [] -> #(None, parts)
  }
}

/// Parse variant subtags.
///
/// Variants can be:
/// - 5-8 alphanumeric characters
/// - 4 characters starting with a digit
fn parse_variants(parts: List(String)) -> #(List(String), List(String)) {
  parse_variants_helper(parts, [])
}

/// Helper function to parse multiple variant subtags.
fn parse_variants_helper(
  parts: List(String),
  acc: List(String),
) -> #(List(String), List(String)) {
  case parts {
    [part, ..rest] ->
      case is_valid_variant(part) {
        True -> parse_variants_helper(rest, [part, ..acc])
        False -> #(list.reverse(acc), parts)
      }
    [] -> #(list.reverse(acc), parts)
  }
}

/// Check if a string is a valid variant subtag.
fn is_valid_variant(part: String) -> Bool {
  let len = string.length(part)
  case len >= 5 && len <= 8 && is_all_alphanum(part) {
    True -> True
    False ->
      case len == 4 {
        True ->
          case string.to_graphemes(part) {
            [first, ..rest] -> is_digit(first) && list.all(rest, is_alphanum)
            _ -> False
          }
        False -> False
      }
  }
}

/// Parse extension subtags.
///
/// Extensions have the format: singleton-subtag1[-subtag2]...
/// where singleton is a single character (except 'x') and subtags are 2-8 alphanumeric characters.
fn parse_extensions(parts: List(String)) -> #(List(Extension), List(String)) {
  parse_extensions_helper(parts, [])
}

/// Helper function to parse multiple extensions.
fn parse_extensions_helper(
  parts: List(String),
  acc: List(Extension),
) -> #(List(Extension), List(String)) {
  case parts {
    [singleton_part, ..rest] ->
      case is_singleton(singleton_part) && singleton_part != "x" {
        True -> {
          let #(subtags, remaining) = parse_extension_subtags(rest)
          case subtags {
            [] -> #(list.reverse(acc), parts)
            // No valid subtags found
            _ -> {
              let extension =
                Extension(singleton: singleton_part, subtags: subtags)
              parse_extensions_helper(remaining, [extension, ..acc])
            }
          }
        }
        False -> #(list.reverse(acc), parts)
      }
    [] -> #(list.reverse(acc), parts)
  }
}

/// Parse subtags for an extension.
fn parse_extension_subtags(parts: List(String)) -> #(List(String), List(String)) {
  parse_extension_subtags_helper(parts, [])
}

/// Helper function to parse extension subtags.
fn parse_extension_subtags_helper(
  parts: List(String),
  acc: List(String),
) -> #(List(String), List(String)) {
  case parts {
    [part, ..rest] -> {
      let len = string.length(part)
      case
        len >= 2 && len <= 8 && is_all_alphanum(part) && !is_singleton(part)
      {
        True -> parse_extension_subtags_helper(rest, [part, ..acc])
        False -> #(list.reverse(acc), parts)
      }
    }
    [] -> #(list.reverse(acc), parts)
  }
}

/// Parse private use subtags within a language tag.
///
/// Private use in language tags has the format: x-subtag1[-subtag2]...
fn parse_privateuse_in_langtag(
  parts: List(String),
) -> #(Option(String), List(String)) {
  case parts {
    ["x", ..subtags] -> {
      case
        list.all(subtags, fn(subtag) {
          let len = string.length(subtag)
          len >= 1 && len <= 8 && is_all_alphanum(subtag)
        })
        && list.length(subtags) >= 1
      {
        True -> #(Some(string.join(subtags, "-")), [])
        False -> #(None, parts)
      }
    }
    _ -> #(None, parts)
  }
}

/// Check if a string is a valid singleton character.
///
/// Singletons are single characters that can be digits (0-9) or letters (a-z, A-Z)
/// excluding 'x' and 'X' which are reserved for private use.
fn is_singleton(part: String) -> Bool {
  case string.length(part) == 1 {
    True ->
      case string.to_utf_codepoints(part) {
        [codepoint] -> {
          let code = string.utf_codepoint_to_int(codepoint)
          { code >= 48 && code <= 57 }
          // 0-9
          || { code >= 65 && code <= 87 }
          // A-W
          || { code >= 89 && code <= 90 }
          // Y-Z
          || { code >= 97 && code <= 119 }
          // a-w
          || { code >= 121 && code <= 122 }
          // y-z
        }
        _ -> False
      }
    False -> False
  }
}

// Helper functions for character classification

/// Check if a character is alphabetic (a-z, A-Z).
fn is_alpha(char: String) -> Bool {
  case string.to_utf_codepoints(char) {
    [codepoint] -> {
      let code = string.utf_codepoint_to_int(codepoint)
      { code >= 65 && code <= 90 } || { code >= 97 && code <= 122 }
    }
    _ -> False
  }
}

/// Check if a character is a digit (0-9).
fn is_digit(char: String) -> Bool {
  case string.to_utf_codepoints(char) {
    [codepoint] -> {
      let code = string.utf_codepoint_to_int(codepoint)
      code >= 48 && code <= 57
    }
    _ -> False
  }
}

/// Check if a character is alphanumeric (a-z, A-Z, 0-9).
fn is_alphanum(char: String) -> Bool {
  is_alpha(char) || is_digit(char)
}

/// Check if all characters in a string are alphabetic.
fn is_all_alpha(s: String) -> Bool {
  string.to_graphemes(s)
  |> list.all(is_alpha)
}

/// Check if all characters in a string are digits.
fn is_all_digit(s: String) -> Bool {
  string.to_graphemes(s)
  |> list.all(is_digit)
}

/// Check if all characters in a string are alphanumeric.
fn is_all_alphanum(s: String) -> Bool {
  string.to_graphemes(s)
  |> list.all(is_alphanum)
}
