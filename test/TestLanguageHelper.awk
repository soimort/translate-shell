@include "include/LanguageData"
@include "include/LanguageHelper"

BEGIN {
    START_TEST("LanguageHelper.awk")

    T("getCode()", 5)
    {
        initLocale()
        initLocaleAlias()
        initLocaleDisplay()

        assertEqual(getCode("chinese"), "zh-CN")
        assertEqual(getCode("简体中文"), "zh-CN")
        assertEqual(getCode("正體中文"), "zh-TW")
        assertEqual(getCode("Japanese"), "ja")
        assertEqual(getCode("日本語"), "ja")
    }

    END_TEST()
}
