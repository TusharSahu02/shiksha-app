import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfExportService {
  PdfExportService._();

  static const _orange = PdfColor.fromInt(0xFFF0A030);
  static const _dark = PdfColor.fromInt(0xFF1B2A4A);
  static const _grey = PdfColor.fromInt(0xFF6B7280);

  static Future<void> exportCampaign(Map<String, dynamic> campaign) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        header: (context) => _buildHeader('Campaign'),
        footer: (context) => _buildFooter(context),
        build: (context) => [
          if (campaign['headline'] != null)
            _title(campaign['headline'] as String),
          if (campaign['subheadline'] != null)
            _subtitle(campaign['subheadline'] as String),
          pw.SizedBox(height: 16),
          if (campaign['body'] != null)
            _bodyText(campaign['body'] as String),
          if (campaign['cta'] != null)
            _labeledBlock('Call to Action', campaign['cta'] as String),
          if (campaign['whatsapp_message'] != null)
            _labeledBlock('WhatsApp Message', campaign['whatsapp_message'] as String),
          if (campaign['sms_text'] != null)
            _labeledBlock('SMS Text', campaign['sms_text'] as String),
          if (campaign['key_benefits'] != null)
            _bulletList('Key Benefits', campaign['key_benefits'] as List),
          if (campaign['hashtags'] != null)
            _labeledBlock('Hashtags', (campaign['hashtags'] as List).join('  ')),
          if (campaign['target_audience'] != null)
            _labeledBlock('Target Audience', campaign['target_audience'] as String),
          if (campaign['raw_text'] != null)
            _bodyText(campaign['raw_text'] as String),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (_) => pdf.save(),
      name: 'campaign.pdf',
    );
  }

  static Future<void> exportPrintMaterial(Map<String, dynamic> material) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        header: (context) => _buildHeader('Print Material'),
        footer: (context) => _buildFooter(context),
        build: (context) {
          final widgets = <pw.Widget>[];

          if (material['title'] != null) {
            widgets.add(_title(material['title'] as String));
          }
          if (material['subtitle'] != null) {
            widgets.add(_subtitle(material['subtitle'] as String));
          }
          widgets.add(pw.SizedBox(height: 16));

          final sections = material['sections'] as List?;
          if (sections != null) {
            for (final section in sections) {
              if (section is Map<String, dynamic>) {
                widgets.add(
                  _labeledBlock(
                    section['heading'] as String? ?? '',
                    section['content'] as String? ?? '',
                  ),
                );
              }
            }
          }

          if (material['key_highlights'] != null) {
            widgets.add(
              _bulletList('Key Highlights', material['key_highlights'] as List),
            );
          }
          if (material['call_to_action'] != null) {
            widgets.add(
              _labeledBlock('Call to Action', material['call_to_action'] as String),
            );
          }
          if (material['contact_block'] != null) {
            widgets.add(
              _labeledBlock('Contact', material['contact_block'] as String),
            );
          }
          if (material['design_notes'] != null) {
            widgets.add(
              _labeledBlock('Design Notes', material['design_notes'] as String),
            );
          }
          if (material['whatsapp_message'] != null) {
            widgets.add(
              _labeledBlock('WhatsApp Message', material['whatsapp_message'] as String),
            );
          }
          if (material['footer_text'] != null) {
            widgets.add(
              _labeledBlock('Footer', material['footer_text'] as String),
            );
          }
          if (material['raw_text'] != null) {
            widgets.add(_bodyText(material['raw_text'] as String));
          }

          return widgets;
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (_) => pdf.save(),
      name: 'print-material.pdf',
    );
  }

  static Future<void> exportReelScript(Map<String, dynamic> script) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        header: (context) => _buildHeader('Reel Script'),
        footer: (context) => _buildFooter(context),
        build: (context) {
          final widgets = <pw.Widget>[];

          if (script['title'] != null) {
            widgets.add(_title(script['title'] as String));
          }

          if (script['hook'] != null) {
            widgets.add(_labeledBlock('Hook', script['hook'] as String));
          }

          final scenes = script['scenes'] as List? ?? [];
          if (scenes.isNotEmpty) {
            for (final scene in scenes) {
              if (scene is Map<String, dynamic>) {
                final sceneText = StringBuffer();
                sceneText.writeln('Visual: ${scene['visual'] ?? ''}');
                if (scene['text_overlay'] != null && (scene['text_overlay'] as String).isNotEmpty) {
                  sceneText.writeln('Caption: ${scene['text_overlay']}');
                }
                if (scene['audio_cue'] != null && (scene['audio_cue'] as String).isNotEmpty) {
                  sceneText.writeln('Audio: ${scene['audio_cue']}');
                }
                if (scene['transition'] != null) {
                  sceneText.writeln('Transition: ${scene['transition']}');
                }
                widgets.add(
                  _labeledBlock(
                    'Scene ${scene['scene_number']} (${scene['duration'] ?? ''})',
                    sceneText.toString().trim(),
                  ),
                );
              }
            }
          }

          if (script['voiceover_script'] != null && (script['voiceover_script'] as String).isNotEmpty) {
            widgets.add(_labeledBlock('Voiceover Script', script['voiceover_script'] as String));
          }

          final captions = script['caption_sequence'] as List? ?? [];
          if (captions.isNotEmpty) {
            widgets.add(_bulletList('Caption Sequence', captions));
          }

          if (script['music_recommendation'] != null) {
            widgets.add(_labeledBlock('Music', script['music_recommendation'] as String));
          }

          final hashtags = script['hashtags'] as List? ?? [];
          if (hashtags.isNotEmpty) {
            widgets.add(
              _labeledBlock(
                'Hashtags',
                hashtags.map((t) => t.toString().startsWith('#') ? t : '#$t').join('  '),
              ),
            );
          }

          if (script['posting_tips'] != null) {
            widgets.add(_labeledBlock('Posting Tips', script['posting_tips'] as String));
          }

          if (script['estimated_engagement'] != null) {
            widgets.add(_labeledBlock('Estimated Engagement', script['estimated_engagement'] as String));
          }

          if (script['raw_text'] != null) {
            widgets.add(_bodyText(script['raw_text'] as String));
          }

          return widgets;
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (_) => pdf.save(),
      name: 'reel-script.pdf',
    );
  }

  static pw.Widget _buildHeader(String type) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 20),
      padding: const pw.EdgeInsets.only(bottom: 10),
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: _orange, width: 2)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.RichText(
            text: pw.TextSpan(
              children: [
                pw.TextSpan(
                  text: 'Shiksha ',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                    color: _dark,
                  ),
                ),
                pw.TextSpan(
                  text: 'Studio',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                    color: _orange,
                    fontStyle: pw.FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          pw.Text(
            type,
            style: pw.TextStyle(fontSize: 12, color: _grey),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildFooter(pw.Context context) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 10),
      padding: const pw.EdgeInsets.only(top: 8),
      decoration: const pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: PdfColors.grey300)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Generated by Shiksha',
            style: pw.TextStyle(fontSize: 9, color: _grey),
          ),
          pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: pw.TextStyle(fontSize: 9, color: _grey),
          ),
        ],
      ),
    );
  }

  static pw.Widget _title(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 22,
          fontWeight: pw.FontWeight.bold,
          color: _dark,
        ),
      ),
    );
  }

  static pw.Widget _subtitle(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 14,
          color: _orange,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  static pw.Widget _bodyText(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 16),
      child: pw.Text(
        text,
        style: const pw.TextStyle(fontSize: 11, color: _dark, lineSpacing: 5),
      ),
    );
  }

  static pw.Widget _labeledBlock(String label, String content) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 16),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: pw.BoxDecoration(
              color: const PdfColor.fromInt(0xFFFFF3E0),
              borderRadius: pw.BorderRadius.circular(4),
            ),
            child: pw.Text(
              label.toUpperCase(),
              style: pw.TextStyle(
                fontSize: 9,
                fontWeight: pw.FontWeight.bold,
                color: _orange,
                letterSpacing: 0.5,
              ),
            ),
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            content,
            style: const pw.TextStyle(fontSize: 11, color: _dark, lineSpacing: 5),
          ),
        ],
      ),
    );
  }

  static pw.Widget _bulletList(String label, List items) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 16),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: pw.BoxDecoration(
              color: const PdfColor.fromInt(0xFFFFF3E0),
              borderRadius: pw.BorderRadius.circular(4),
            ),
            child: pw.Text(
              label.toUpperCase(),
              style: pw.TextStyle(
                fontSize: 9,
                fontWeight: pw.FontWeight.bold,
                color: _orange,
                letterSpacing: 0.5,
              ),
            ),
          ),
          pw.SizedBox(height: 6),
          ...items.map(
            (item) => pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 4, left: 8),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('\u2022 ', style: pw.TextStyle(fontSize: 11, color: _orange)),
                  pw.Expanded(
                    child: pw.Text(
                      '$item',
                      style: const pw.TextStyle(fontSize: 11, color: _dark),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
