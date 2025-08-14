////
//// Test suite for tongue_tied, a BCP47 language tag parser for Gleam.
////
//// These tests were copied from the https://github.com/wooorm/bcp-47
////

import gleam/option.{None, Some}
import gleeunit
import tongue_tied

// Assuming your parser module is named tongue_tied

pub fn main() {
  gleeunit.main()
}

// Test zh-yue: language with extended language subtag
pub fn zh_yue_test() {
  let result = tongue_tied.parse_language_tag("zh-yue")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "zh-yue",
      script: None,
      region: None,
      variants: [],
      extensions: [],
      privateuse: None,
    ))
}

// Test zh-yue-HK: language with extended language subtag and region
pub fn zh_yue_hk_test() {
  let result = tongue_tied.parse_language_tag("zh-yue-HK")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "zh-yue",
      script: None,
      region: Some("hk"),
      variants: [],
      extensions: [],
      privateuse: None,
    ))
}

// Test zh-xiang: regular grandfathered tag
pub fn zh_xiang_test() {
  let result = tongue_tied.parse_language_tag("zh-xiang")
  assert result == Ok(tongue_tied.Grandfathered("zh-xiang"))
}

// Test zh-min: regular grandfathered tag
pub fn zh_min_test() {
  let result = tongue_tied.parse_language_tag("zh-min")
  assert result == Ok(tongue_tied.Grandfathered("zh-min"))
}

// Test zh-min-nan: regular grandfathered tag
pub fn zh_min_nan_test() {
  let result = tongue_tied.parse_language_tag("zh-min-nan")
  assert result == Ok(tongue_tied.Grandfathered("zh-min-nan"))
}

// Test zh-hakka: regular grandfathered tag
pub fn zh_hakka_test() {
  let result = tongue_tied.parse_language_tag("zh-hakka")
  assert result == Ok(tongue_tied.Grandfathered("zh-hakka"))
}

// Test zh-guoyu: regular grandfathered tag
pub fn zh_guoyu_test() {
  let result = tongue_tied.parse_language_tag("zh-guoyu")
  assert result == Ok(tongue_tied.Grandfathered("zh-guoyu"))
}

// Test zh-cmn-Hans-CN: language with extended language, script, and region
pub fn zh_cmn_hans_cn_test() {
  let result = tongue_tied.parse_language_tag("zh-cmn-Hans-CN")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "zh-cmn",
      script: Some("hans"),
      region: Some("cn"),
      variants: [],
      extensions: [],
      privateuse: None,
    ))
}

// Test zh-Hant: language with script
pub fn zh_hant_test() {
  let result = tongue_tied.parse_language_tag("zh-Hant")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "zh",
      script: Some("hant"),
      region: None,
      variants: [],
      extensions: [],
      privateuse: None,
    ))
}

// Test zh-Hant-HK: language with script and region
pub fn zh_hant_hk_test() {
  let result = tongue_tied.parse_language_tag("zh-Hant-HK")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "zh",
      script: Some("hant"),
      region: Some("hk"),
      variants: [],
      extensions: [],
      privateuse: None,
    ))
}

// Test zh-Hans: language with script
pub fn zh_hans_test() {
  let result = tongue_tied.parse_language_tag("zh-Hans")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "zh",
      script: Some("hans"),
      region: None,
      variants: [],
      extensions: [],
      privateuse: None,
    ))
}

// Test zh-Hans-CN: language with script and region
pub fn zh_hans_cn_test() {
  let result = tongue_tied.parse_language_tag("zh-Hans-CN")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "zh",
      script: Some("hans"),
      region: Some("cn"),
      variants: [],
      extensions: [],
      privateuse: None,
    ))
}

// Test zh-CN-a-myext-x-private: language with region, extension, and private use
pub fn zh_cn_extension_private_test() {
  let result = tongue_tied.parse_language_tag("zh-CN-a-myext-x-private")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "zh",
      script: None,
      region: Some("cn"),
      variants: [],
      extensions: [tongue_tied.Extension(singleton: "a", subtags: ["myext"])],
      privateuse: Some("private"),
    ))
}

// Test yue-HK: 3-letter language code with region
pub fn yue_hk_test() {
  let result = tongue_tied.parse_language_tag("yue-HK")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "yue",
      script: None,
      region: Some("hk"),
      variants: [],
      extensions: [],
      privateuse: None,
    ))
}

// Test x-whatever: simple private use tag
pub fn x_whatever_test() {
  let result = tongue_tied.parse_language_tag("x-whatever")
  assert result == Ok(tongue_tied.PrivateUse("x-whatever"))
}

// Test x-111-aaaaa-BBB: complex private use tag with multiple subtags
pub fn x_complex_private_test() {
  let result = tongue_tied.parse_language_tag("x-111-aaaaa-BBB")
  assert result == Ok(tongue_tied.PrivateUse("x-111-aaaaa-bbb"))
}

// Test irregular grandfathered tags
pub fn en_gb_oed_test() {
  let result = tongue_tied.parse_language_tag("en-GB-oed")
  assert result == Ok(tongue_tied.Grandfathered("en-gb-oed"))
}

pub fn i_klingon_test() {
  let result = tongue_tied.parse_language_tag("i-klingon")
  assert result == Ok(tongue_tied.Grandfathered("i-klingon"))
}

pub fn sgn_be_fr_test() {
  let result = tongue_tied.parse_language_tag("sgn-BE-FR")
  assert result == Ok(tongue_tied.Grandfathered("sgn-be-fr"))
}

// Tests from JSON fixtures

// Test qaa-Qaaa-QM-x-southern: private use with all components
pub fn qaa_qaaa_qm_x_southern_test() {
  let result = tongue_tied.parse_language_tag("qaa-Qaaa-QM-x-southern")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "qaa",
      script: Some("qaaa"),
      region: Some("qm"),
      variants: [],
      extensions: [],
      privateuse: Some("southern"),
    ))
}

// Test no-nyn: regular grandfathered tag
pub fn no_nyn_test() {
  let result = tongue_tied.parse_language_tag("no-nyn")
  assert result == Ok(tongue_tied.Grandfathered("no-nyn"))
}

// Test no-bok: regular grandfathered tag
pub fn no_bok_test() {
  let result = tongue_tied.parse_language_tag("no-bok")
  assert result == Ok(tongue_tied.Grandfathered("no-bok"))
}

// Test mas: simple 3-letter language code
pub fn mas_test() {
  let result = tongue_tied.parse_language_tag("mas")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "mas",
      script: None,
      region: None,
      variants: [],
      extensions: [],
      privateuse: None,
    ))
}

// Test ja: simple 2-letter language code
pub fn ja_test() {
  let result = tongue_tied.parse_language_tag("ja")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "ja",
      script: None,
      region: None,
      variants: [],
      extensions: [],
      privateuse: None,
    ))
}

// Test i-tsu: irregular grandfathered tag
pub fn i_tsu_test() {
  let result = tongue_tied.parse_language_tag("i-tsu")
  assert result == Ok(tongue_tied.Grandfathered("i-tsu"))
}

// Test i-tay: irregular grandfathered tag
pub fn i_tay_test() {
  let result = tongue_tied.parse_language_tag("i-tay")
  assert result == Ok(tongue_tied.Grandfathered("i-tay"))
}

// Test i-tao: irregular grandfathered tag
pub fn i_tao_test() {
  let result = tongue_tied.parse_language_tag("i-tao")
  assert result == Ok(tongue_tied.Grandfathered("i-tao"))
}

// Test i-pwn: irregular grandfathered tag
pub fn i_pwn_test() {
  let result = tongue_tied.parse_language_tag("i-pwn")
  assert result == Ok(tongue_tied.Grandfathered("i-pwn"))
}

// Test i-navajo: irregular grandfathered tag
pub fn i_navajo_test() {
  let result = tongue_tied.parse_language_tag("i-navajo")
  assert result == Ok(tongue_tied.Grandfathered("i-navajo"))
}

// Test i-mingo: irregular grandfathered tag
pub fn i_mingo_test() {
  let result = tongue_tied.parse_language_tag("i-mingo")
  assert result == Ok(tongue_tied.Grandfathered("i-mingo"))
}

// Test i-lux: irregular grandfathered tag
pub fn i_lux_test() {
  let result = tongue_tied.parse_language_tag("i-lux")
  assert result == Ok(tongue_tied.Grandfathered("i-lux"))
}

// Test i-hak: irregular grandfathered tag
pub fn i_hak_test() {
  let result = tongue_tied.parse_language_tag("i-hak")
  assert result == Ok(tongue_tied.Grandfathered("i-hak"))
}

// Test i-enochian: irregular grandfathered tag
pub fn i_enochian_test() {
  let result = tongue_tied.parse_language_tag("i-enochian")
  assert result == Ok(tongue_tied.Grandfathered("i-enochian"))
}

// Test i-default: irregular grandfathered tag
pub fn i_default_test() {
  let result = tongue_tied.parse_language_tag("i-default")
  assert result == Ok(tongue_tied.Grandfathered("i-default"))
}

// Test i-bnn: irregular grandfathered tag
pub fn i_bnn_test() {
  let result = tongue_tied.parse_language_tag("i-bnn")
  assert result == Ok(tongue_tied.Grandfathered("i-bnn"))
}

// Test i-ami: irregular grandfathered tag
pub fn i_ami_test() {
  let result = tongue_tied.parse_language_tag("i-ami")
  assert result == Ok(tongue_tied.Grandfathered("i-ami"))
}

// Test hy-Latn-IT-arevela: language with script, region, and variant
pub fn hy_latn_it_arevela_test() {
  let result = tongue_tied.parse_language_tag("hy-Latn-IT-arevela")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "hy",
      script: Some("latn"),
      region: Some("it"),
      variants: ["arevela"],
      extensions: [],
      privateuse: None,
    ))
}

// Test hak: simple 3-letter language code
pub fn hak_test() {
  let result = tongue_tied.parse_language_tag("hak")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "hak",
      script: None,
      region: None,
      variants: [],
      extensions: [],
      privateuse: None,
    ))
}

// Test fr: simple 2-letter language code
pub fn fr_test() {
  let result = tongue_tied.parse_language_tag("fr")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "fr",
      script: None,
      region: None,
      variants: [],
      extensions: [],
      privateuse: None,
    ))
}

// Test fr-CA: language with region
pub fn fr_ca_test() {
  let result = tongue_tied.parse_language_tag("fr-CA")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "fr",
      script: None,
      region: Some("ca"),
      variants: [],
      extensions: [],
      privateuse: None,
    ))
}

// Test es-419: language with numeric region
pub fn es_419_test() {
  let result = tongue_tied.parse_language_tag("es-419")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "es",
      script: None,
      region: Some("419"),
      variants: [],
      extensions: [],
      privateuse: None,
    ))
}

// Test es-005: language with numeric region
pub fn es_005_test() {
  let result = tongue_tied.parse_language_tag("es-005")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "es",
      script: None,
      region: Some("005"),
      variants: [],
      extensions: [],
      privateuse: None,
    ))
}

// Test en: simple 2-letter language code
pub fn en_test() {
  let result = tongue_tied.parse_language_tag("en")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "en",
      script: None,
      region: None,
      variants: [],
      extensions: [],
      privateuse: None,
    ))
}

// Test en-a-myext-b-another: language with multiple extensions
pub fn en_a_myext_b_another_test() {
  let result = tongue_tied.parse_language_tag("en-a-myext-b-another")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "en",
      script: None,
      region: None,
      variants: [],
      extensions: [
        tongue_tied.Extension(singleton: "a", subtags: ["myext"]),
        tongue_tied.Extension(singleton: "b", subtags: ["another"]),
      ],
      privateuse: None,
    ))
}

// Test en-US: language with region
pub fn en_us_test() {
  let result = tongue_tied.parse_language_tag("en-US")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "en",
      script: None,
      region: Some("us"),
      variants: [],
      extensions: [],
      privateuse: None,
    ))
}

// Test en-US-x-twain: language with region and private use
pub fn en_us_x_twain_test() {
  let result = tongue_tied.parse_language_tag("en-US-x-twain")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "en",
      script: None,
      region: Some("us"),
      variants: [],
      extensions: [],
      privateuse: Some("twain"),
    ))
}

// Test en-US-u-islamcal: language with region and unicode extension
pub fn en_us_u_islamcal_test() {
  let result = tongue_tied.parse_language_tag("en-US-u-islamcal")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "en",
      script: None,
      region: Some("us"),
      variants: [],
      extensions: [tongue_tied.Extension(singleton: "u", subtags: ["islamcal"])],
      privateuse: None,
    ))
}

// Test de: simple 2-letter language code
pub fn de_test() {
  let result = tongue_tied.parse_language_tag("de")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "de",
      script: None,
      region: None,
      variants: [],
      extensions: [],
      privateuse: None,
    ))
}

// Test de-Qaaa: language with private use script
pub fn de_qaaa_test() {
  let result = tongue_tied.parse_language_tag("de-Qaaa")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "de",
      script: Some("qaaa"),
      region: None,
      variants: [],
      extensions: [],
      privateuse: None,
    ))
}

// Test de-DE: language with region
pub fn de_de_test() {
  let result = tongue_tied.parse_language_tag("de-DE")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "de",
      script: None,
      region: Some("de"),
      variants: [],
      extensions: [],
      privateuse: None,
    ))
}

// Test de-DE-u-co-phonebk: language with region and unicode extension with multiple subtags
pub fn de_de_u_co_phonebk_test() {
  let result = tongue_tied.parse_language_tag("de-DE-u-co-phonebk")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "de",
      script: None,
      region: Some("de"),
      variants: [],
      extensions: [
        tongue_tied.Extension(singleton: "u", subtags: ["co", "phonebk"]),
      ],
      privateuse: None,
    ))
}

// Test de-CH-x-phonebk: language with region and private use
pub fn de_ch_x_phonebk_test() {
  let result = tongue_tied.parse_language_tag("de-CH-x-phonebk")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "de",
      script: None,
      region: Some("ch"),
      variants: [],
      extensions: [],
      privateuse: Some("phonebk"),
    ))
}

// Test de-CH-1901: language with region and variant
pub fn de_ch_1901_test() {
  let result = tongue_tied.parse_language_tag("de-CH-1901")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "de",
      script: None,
      region: Some("ch"),
      variants: ["1901"],
      extensions: [],
      privateuse: None,
    ))
}

// Test cmn-Hans-CN: language with script and region
pub fn cmn_hans_cn_test() {
  let result = tongue_tied.parse_language_tag("cmn-Hans-CN")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "cmn",
      script: Some("hans"),
      region: Some("cn"),
      variants: [],
      extensions: [],
      privateuse: None,
    ))
}

// Test cel-gaulish: regular grandfathered tag
pub fn cel_gaulish_test() {
  let result = tongue_tied.parse_language_tag("cel-gaulish")
  assert result == Ok(tongue_tied.Grandfathered("cel-gaulish"))
}

// Test az-Latn: language with script
pub fn az_latn_test() {
  let result = tongue_tied.parse_language_tag("az-Latn")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "az",
      script: Some("latn"),
      region: None,
      variants: [],
      extensions: [],
      privateuse: None,
    ))
}

// Test az-Arab-x-AZE-derbend: language with script and multiple private use subtags
pub fn az_arab_x_aze_derbend_test() {
  let result = tongue_tied.parse_language_tag("az-Arab-x-AZE-derbend")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "az",
      script: Some("arab"),
      region: None,
      variants: [],
      extensions: [],
      privateuse: Some("aze-derbend"),
    ))
}

// Test ast: simple 3-letter language code
pub fn ast_test() {
  let result = tongue_tied.parse_language_tag("ast")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "ast",
      script: None,
      region: None,
      variants: [],
      extensions: [],
      privateuse: None,
    ))
}

// Test art-lojban: regular grandfathered tag
pub fn art_lojban_test() {
  let result = tongue_tied.parse_language_tag("art-lojban")
  assert result == Ok(tongue_tied.Grandfathered("art-lojban"))
}

// Test ar-afb: language with extended language subtag
pub fn ar_afb_test() {
  let result = tongue_tied.parse_language_tag("ar-afb")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "ar-afb",
      script: None,
      region: None,
      variants: [],
      extensions: [],
      privateuse: None,
    ))
}

// Test afb: simple 3-letter language code
pub fn afb_test() {
  let result = tongue_tied.parse_language_tag("afb")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "afb",
      script: None,
      region: None,
      variants: [],
      extensions: [],
      privateuse: None,
    ))
}

// Test aaaaaaaa: 8-letter language code
pub fn aaaaaaaa_test() {
  let result = tongue_tied.parse_language_tag("aaaaaaaa")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "aaaaaaaa",
      script: None,
      region: None,
      variants: [],
      extensions: [],
      privateuse: None,
    ))
}

// Test aaaaaaa: 7-letter language code
pub fn aaaaaaa_test() {
  let result = tongue_tied.parse_language_tag("aaaaaaa")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "aaaaaaa",
      script: None,
      region: None,
      variants: [],
      extensions: [],
      privateuse: None,
    ))
}

// Test aaaaaa: 6-letter language code
pub fn aaaaaa_test() {
  let result = tongue_tied.parse_language_tag("aaaaaa")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "aaaaaa",
      script: None,
      region: None,
      variants: [],
      extensions: [],
      privateuse: None,
    ))
}

// Test aaaaa: 5-letter language code
pub fn aaaaa_test() {
  let result = tongue_tied.parse_language_tag("aaaaa")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "aaaaa",
      script: None,
      region: None,
      variants: [],
      extensions: [],
      privateuse: None,
    ))
}

// Test aaaa: 4-letter language code
pub fn aaaa_test() {
  let result = tongue_tied.parse_language_tag("aaaa")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "aaaa",
      script: None,
      region: None,
      variants: [],
      extensions: [],
      privateuse: None,
    ))
}

// Test aaa-bbb-ccc: language with multiple extended language subtags
pub fn aaa_bbb_ccc_test() {
  let result = tongue_tied.parse_language_tag("aaa-bbb-ccc")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "aaa-bbb-ccc",
      script: None,
      region: None,
      variants: [],
      extensions: [],
      privateuse: None,
    ))
}

// Test complex tag with all components
pub fn aaa_bbb_ccc_ddd_abcd_123_abc123_0abc_b_01_abc123_x_01ab_abc12_test() {
  let result =
    tongue_tied.parse_language_tag(
      "aaa-bbb-ccc-ddd-abcd-123-abc123-0abc-b-01-abc123-x-01ab-abc12",
    )
  assert result
    == Ok(tongue_tied.LangTag(
      language: "aaa-bbb-ccc-ddd",
      script: Some("abcd"),
      region: Some("123"),
      variants: ["abc123", "0abc"],
      extensions: [
        tongue_tied.Extension(singleton: "b", subtags: ["01", "abc123"]),
      ],
      privateuse: Some("01ab-abc12"),
    ))
}

// Test aa: 2-letter language code
pub fn aa_test() {
  let result = tongue_tied.parse_language_tag("aa")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "aa",
      script: None,
      region: None,
      variants: [],
      extensions: [],
      privateuse: None,
    ))
}

// Test aa-x-1234ab-d: language with multiple private use subtags
pub fn aa_x_1234ab_d_test() {
  let result = tongue_tied.parse_language_tag("aa-x-1234ab-d")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "aa",
      script: None,
      region: None,
      variants: [],
      extensions: [],
      privateuse: Some("1234ab-d"),
    ))
}

// Test aa-bbbb: language with 4-letter script
pub fn aa_bbbb_test() {
  let result = tongue_tied.parse_language_tag("aa-bbbb")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "aa",
      script: Some("bbbb"),
      region: None,
      variants: [],
      extensions: [],
      privateuse: None,
    ))
}

// Test aa-bbbb-cc: language with script and 2-letter region
pub fn aa_bbbb_cc_test() {
  let result = tongue_tied.parse_language_tag("aa-bbbb-cc")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "aa",
      script: Some("bbbb"),
      region: Some("cc"),
      variants: [],
      extensions: [],
      privateuse: None,
    ))
}

// Test aa-bbb: language with extended language subtag
pub fn aa_bbb_test() {
  let result = tongue_tied.parse_language_tag("aa-bbb")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "aa-bbb",
      script: None,
      region: None,
      variants: [],
      extensions: [],
      privateuse: None,
    ))
}

// Test aa-bbb-ccc-ddd: language with multiple extended language subtags
pub fn aa_bbb_ccc_ddd_test() {
  let result = tongue_tied.parse_language_tag("aa-bbb-ccc-ddd")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "aa-bbb-ccc-ddd",
      script: None,
      region: None,
      variants: [],
      extensions: [],
      privateuse: None,
    ))
}

// Test aa-bbb-ccc-1111-ccccc-b1b1b: language with extended subtags and variants
pub fn aa_bbb_ccc_1111_ccccc_b1b1b_test() {
  let result = tongue_tied.parse_language_tag("aa-bbb-ccc-1111-ccccc-b1b1b")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "aa-bbb-ccc",
      script: None,
      region: None,
      variants: ["1111", "ccccc", "b1b1b"],
      extensions: [],
      privateuse: None,
    ))
}

// Test aa-bb: language with 2-letter region
pub fn aa_bb_test() {
  let result = tongue_tied.parse_language_tag("aa-bb")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "aa",
      script: None,
      region: Some("bb"),
      variants: [],
      extensions: [],
      privateuse: None,
    ))
}

// Test aa-b1b1b: language with variant
pub fn aa_b1b1b_test() {
  let result = tongue_tied.parse_language_tag("aa-b1b1b")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "aa",
      script: None,
      region: None,
      variants: ["b1b1b"],
      extensions: [],
      privateuse: None,
    ))
}

// Test aa-b1b1b-6a8b-cccccc: language with multiple variants
pub fn aa_b1b1b_6a8b_cccccc_test() {
  let result = tongue_tied.parse_language_tag("aa-b1b1b-6a8b-cccccc")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "aa",
      script: None,
      region: None,
      variants: ["b1b1b", "6a8b", "cccccc"],
      extensions: [],
      privateuse: None,
    ))
}

// Test aa-7-123abc-abc-a-12: language with numeric and letter singleton extensions
pub fn aa_7_123abc_abc_a_12_test() {
  let result = tongue_tied.parse_language_tag("aa-7-123abc-abc-a-12")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "aa",
      script: None,
      region: None,
      variants: [],
      extensions: [
        tongue_tied.Extension(singleton: "7", subtags: ["123abc", "abc"]),
        tongue_tied.Extension(singleton: "a", subtags: ["12"]),
      ],
      privateuse: None,
    ))
}

// Test aa-111: language with 3-digit region
pub fn aa_111_test() {
  let result = tongue_tied.parse_language_tag("aa-111")
  assert result
    == Ok(tongue_tied.LangTag(
      language: "aa",
      script: None,
      region: Some("111"),
      variants: [],
      extensions: [],
      privateuse: None,
    ))
}
