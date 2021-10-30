import 'dart:convert';
import 'dart:io';

import 'package:arb_file_parser/arb_file_parser.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() async {
  group('Flutter Gallery ', () {
    for (final locale in flutterGalleryLocales) {
      downloadAndParse(
        'https://raw.githubusercontent.com/flutter/gallery/master/lib/l10n/$locale',
        locale,
      );
    }
  });
}

Future<void> downloadAndParse(String url, String name) async {
  test(name, () async {
    final http = HttpClient();
    final req = await http.getUrl(Uri.parse(url));
    final res = await req.close();
    final body = await res.transform(Utf8Decoder()).join();
    http.close();
    final parsed = ArbFileParser().parse(body);
    expect(1 + 1, 2);
  });
}

const flutterGalleryLocales = [
  "intl_af.arb",
  "intl_am.arb",
  "intl_ar.arb",
  "intl_ar_EG.arb",
  "intl_ar_JO.arb",
  "intl_ar_MA.arb",
  "intl_ar_SA.arb",
  "intl_as.arb",
  "intl_az.arb",
  "intl_be.arb",
  "intl_bg.arb",
  "intl_bn.arb",
  "intl_bs.arb",
  "intl_ca.arb",
  "intl_cs.arb",
  "intl_da.arb",
  "intl_de.arb",
  "intl_de_AT.arb",
  "intl_de_CH.arb",
  "intl_el.arb",
  "intl_en.arb",
  "intl_en_AU.arb",
  "intl_en_CA.arb",
  "intl_en_GB.arb",
  "intl_en_IE.arb",
  "intl_en_IN.arb",
  "intl_en_NZ.arb",
  "intl_en_SG.arb",
  // "intl_en_US.xml", not you
  "intl_en_ZA.arb",
  "intl_es.arb",
  "intl_es_419.arb",
  "intl_es_AR.arb",
  "intl_es_BO.arb",
  "intl_es_CL.arb",
  "intl_es_CO.arb",
  "intl_es_CR.arb",
  "intl_es_DO.arb",
  "intl_es_EC.arb",
  "intl_es_GT.arb",
  "intl_es_HN.arb",
  "intl_es_MX.arb",
  "intl_es_NI.arb",
  "intl_es_PA.arb",
  "intl_es_PE.arb",
  "intl_es_PR.arb",
  "intl_es_PY.arb",
  "intl_es_SV.arb",
  "intl_es_US.arb",
  "intl_es_UY.arb",
  "intl_es_VE.arb",
  "intl_et.arb",
  "intl_eu.arb",
  "intl_fa.arb",
  "intl_fi.arb",
  "intl_fil.arb",
  "intl_fr.arb",
  "intl_fr_CA.arb",
  "intl_fr_CH.arb",
  "intl_gl.arb",
  "intl_gsw.arb",
  "intl_gu.arb",
  "intl_he.arb",
  "intl_hi.arb",
  "intl_hr.arb",
  "intl_hu.arb",
  "intl_hy.arb",
  "intl_id.arb",
  "intl_is.arb",
  "intl_it.arb",
  "intl_ja.arb",
  "intl_ka.arb",
  "intl_kk.arb",
  "intl_km.arb",
  "intl_kn.arb",
  "intl_ko.arb",
  "intl_ky.arb",
  "intl_lo.arb",
  "intl_lt.arb",
  "intl_lv.arb",
  "intl_mk.arb",
  "intl_ml.arb",
  "intl_mn.arb",
  "intl_mr.arb",
  "intl_ms.arb",
  "intl_my.arb",
  "intl_nb.arb",
  "intl_ne.arb",
  "intl_nl.arb",
  "intl_or.arb",
  "intl_pa.arb",
  "intl_pl.arb",
  "intl_pt.arb",
  "intl_pt_BR.arb",
  "intl_pt_PT.arb",
  "intl_ro.arb",
  "intl_ru.arb",
  "intl_si.arb",
  "intl_sk.arb",
  "intl_sl.arb",
  "intl_sq.arb",
  "intl_sr.arb",
  "intl_sr_Latn.arb",
  "intl_sv.arb",
  "intl_sw.arb",
  "intl_ta.arb",
  "intl_te.arb",
  "intl_th.arb",
  "intl_tl.arb",
  "intl_tr.arb",
  "intl_uk.arb",
  "intl_ur.arb",
  "intl_uz.arb",
  "intl_vi.arb",
  "intl_zh.arb",
  "intl_zh_CN.arb",
  "intl_zh_HK.arb",
  "intl_zh_TW.arb",
  "intl_zu.arb"
];
