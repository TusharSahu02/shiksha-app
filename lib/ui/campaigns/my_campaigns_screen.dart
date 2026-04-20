import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/models/campaign_history.dart';
import '../../services/pdf_export_service.dart';
import '../../theme/app_colors.dart';
import 'campaigns_view_model.dart';

class MyCampaignsScreen extends StatelessWidget {
  const MyCampaignsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CampaignsViewModel(),
      child: const _CampaignsView(),
    );
  }
}

class _CampaignsView extends StatelessWidget {
  const _CampaignsView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CampaignsViewModel>();
    final filtered = vm.campaigns;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F2),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Campaigns',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${vm.totalCount} campaign${vm.totalCount == 1 ? '' : 's'} generated',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: vm.searchController,
                    onChanged: vm.onSearchChanged,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.primaryDark,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search topic, country or type...',
                      hintStyle: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary.withValues(alpha: 0.5),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        size: 20,
                        color: AppColors.textSecondary,
                      ),
                      suffixIcon: vm.searchController.text.isNotEmpty
                          ? GestureDetector(
                              onTap: vm.clearSearch,
                              child: Icon(
                                Icons.close,
                                size: 18,
                                color: AppColors.textSecondary,
                              ),
                            )
                          : null,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.secondary),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: vm.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filtered.isEmpty
                      ? _EmptyState(
                          hasSearch: vm.searchController.text.isNotEmpty,
                        )
                      : RefreshIndicator(
                          onRefresh: vm.refresh,
                          color: AppColors.secondary,
                          child: _CampaignList(campaigns: filtered, vm: vm),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool hasSearch;
  const _EmptyState({required this.hasSearch});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            hasSearch ? Icons.search_off : Icons.description_outlined,
            size: 56,
            color: AppColors.textSecondary.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(
            hasSearch ? 'No matching campaigns' : 'No campaigns yet',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            hasSearch
                ? 'Try a different search term.'
                : 'Generate your first campaign to see it here.',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _CampaignList extends StatelessWidget {
  final List<CampaignHistory> campaigns;
  final CampaignsViewModel vm;
  const _CampaignList({required this.campaigns, required this.vm});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      itemCount: campaigns.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final c = campaigns[index];
        return Dismissible(
          key: ValueKey(c.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEBEE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.delete_outline, color: Color(0xFFD32F2F)),
          ),
          confirmDismiss: (_) async {
            return await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: const Text('Delete Campaign'),
                content: const Text('This cannot be undone.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFD32F2F),
                    ),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            );
          },
          onDismissed: (_) => vm.delete(c.id),
          child: _CampaignTile(
            campaign: c,
            onTap: () => _showDetail(context, c),
          ),
        );
      },
    );
  }

  void _showDetail(BuildContext context, CampaignHistory campaign) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _DetailSheet(campaign: campaign),
    );
  }
}

class _CampaignTile extends StatelessWidget {
  final CampaignHistory campaign;
  final VoidCallback onTap;
  const _CampaignTile({required this.campaign, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final typeColor = switch (campaign.type) {
      CampaignType.text => const Color(0xFF1565C0),
      CampaignType.image => const Color(0xFF6A1B9A),
      CampaignType.video => const Color(0xFFE65100),
      CampaignType.print => const Color(0xFF2E7D32),
    };

    final typeIcon = switch (campaign.type) {
      CampaignType.text => Icons.text_fields,
      CampaignType.image => Icons.image_outlined,
      CampaignType.video => Icons.videocam_outlined,
      CampaignType.print => Icons.description_outlined,
    };

    final daysAgo = DateTime.now().difference(campaign.createdAt).inDays;
    final expiresIn = 7 - daysAgo;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE8E8E8)),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: typeColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(typeIcon, size: 22, color: typeColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    campaign.topic,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: typeColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          campaign.type.label,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: typeColor,
                          ),
                        ),
                      ),
                      if (campaign.country.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Text(
                          campaign.country,
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatDate(campaign.createdAt),
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  expiresIn <= 1 ? 'Expires today' : '${expiresIn}d left',
                  style: TextStyle(
                    fontSize: 10,
                    color: expiresIn <= 2
                        ? const Color(0xFFD32F2F)
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.chevron_right,
              size: 18,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day} ${months[date.month - 1]}';
  }
}

class _DetailSheet extends StatelessWidget {
  final CampaignHistory campaign;
  const _DetailSheet({required this.campaign});

  @override
  Widget build(BuildContext context) {
    final output = campaign.output;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 0.92,
      minChildSize: 0.4,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD0D0D0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    Icon(
                      Icons.history,
                      size: 20,
                      color: AppColors.secondary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        campaign.topic,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, size: 20),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _TypeChip(type: campaign.type),
                    if (campaign.country.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Text(
                        '${campaign.country}${campaign.language.isNotEmpty ? ' \u2022 ${campaign.language}' : ''}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                    const Spacer(),
                    Text(
                      _formatDateTime(campaign.createdAt),
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              Expanded(
                child: output.isEmpty
                    ? Center(
                        child: Text(
                          'No output data available',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      )
                    : ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.all(20),
                        children: _buildOutputSections(output),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 46,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(text: _buildCopyText(output)),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Copied to clipboard!'),
                                behavior: SnackBarBehavior.floating,
                                duration: const Duration(seconds: 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.copy, size: 18),
                          label: const Text(
                            'Copy All',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.secondary,
                            side: BorderSide(color: AppColors.secondary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 46,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final box =
                                context.findRenderObject() as RenderBox?;
                            await SharePlus.instance.share(
                              ShareParams(
                                text: _buildCopyText(output),
                                sharePositionOrigin: box != null
                                    ? box.localToGlobal(Offset.zero) & box.size
                                    : null,
                              ),
                            );
                          },
                          icon: const Icon(Icons.share, size: 18),
                          label: const Text(
                            'Share',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        PdfExportService.exportCampaign(output),
                    icon: const Icon(Icons.picture_as_pdf, size: 18),
                    label: const Text(
                      'Download PDF',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryDark,
                      side: BorderSide(
                        color: AppColors.primaryDark.withValues(alpha: 0.3),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildOutputSections(Map<String, dynamic> output) {
    final widgets = <Widget>[];

    for (final entry in output.entries) {
      final key = entry.key;
      final value = entry.value;
      if (value == null) continue;

      final label = _formatKey(key);

      if (value is List) {
        if (value.isEmpty) continue;
        if (value.first is Map) {
          for (var i = 0; i < value.length; i++) {
            final map = value[i] as Map<String, dynamic>;
            widgets.add(_SectionLabel('$label ${i + 1}'));
            for (final sub in map.entries) {
              if (sub.value == null || sub.value.toString().isEmpty) continue;
              widgets.add(_SubField(
                label: _formatKey(sub.key),
                content: sub.value.toString(),
              ));
            }
            widgets.add(const SizedBox(height: 12));
          }
        } else {
          widgets.add(_SectionLabel(label));
          widgets.add(_ContentText(value.join('\n')));
          widgets.add(const SizedBox(height: 16));
        }
      } else if (value is Map) {
        widgets.add(_SectionLabel(label));
        for (final sub in (value as Map<String, dynamic>).entries) {
          if (sub.value == null || sub.value.toString().isEmpty) continue;
          widgets.add(_SubField(
            label: _formatKey(sub.key),
            content: sub.value.toString(),
          ));
        }
        widgets.add(const SizedBox(height: 12));
      } else {
        final text = value.toString();
        if (text.isEmpty) continue;
        widgets.add(_SectionLabel(label));
        widgets.add(_ContentText(text));
        widgets.add(const SizedBox(height: 16));
      }
    }

    return widgets;
  }

  String _formatKey(String key) {
    return key.replaceAll('_', ' ').toUpperCase();
  }

  String _buildCopyText(Map<String, dynamic> output) {
    final buffer = StringBuffer();
    for (final entry in output.entries) {
      if (entry.value == null) continue;
      final label = _formatKey(entry.key);
      if (entry.value is List) {
        final list = entry.value as List;
        if (list.isEmpty) continue;
        if (list.first is Map) {
          for (var i = 0; i < list.length; i++) {
            buffer.writeln('$label ${i + 1}:');
            for (final sub in (list[i] as Map).entries) {
              if (sub.value != null && sub.value.toString().isNotEmpty) {
                buffer.writeln('  ${_formatKey(sub.key.toString())}: ${sub.value}');
              }
            }
            buffer.writeln();
          }
        } else {
          buffer.writeln('$label:');
          for (final item in list) {
            buffer.writeln('  - $item');
          }
          buffer.writeln();
        }
      } else if (entry.value is Map) {
        buffer.writeln('$label:');
        for (final sub in (entry.value as Map).entries) {
          if (sub.value != null && sub.value.toString().isNotEmpty) {
            buffer.writeln('  ${_formatKey(sub.key.toString())}: ${sub.value}');
          }
        }
        buffer.writeln();
      } else {
        final text = entry.value.toString();
        if (text.isEmpty) continue;
        buffer.writeln('$label:');
        buffer.writeln(text);
        buffer.writeln();
      }
    }
    return buffer.toString().trim();
  }

  String _formatDateTime(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final h = date.hour > 12 ? date.hour - 12 : date.hour;
    final ampm = date.hour >= 12 ? 'PM' : 'AM';
    final min = date.minute.toString().padLeft(2, '0');
    return '${date.day} ${months[date.month - 1]} \u2022 ${h == 0 ? 12 : h}:$min $ampm';
  }
}

class _TypeChip extends StatelessWidget {
  final CampaignType type;
  const _TypeChip({required this.type});

  @override
  Widget build(BuildContext context) {
    final color = switch (type) {
      CampaignType.text => const Color(0xFF1565C0),
      CampaignType.image => const Color(0xFF6A1B9A),
      CampaignType.video => const Color(0xFFE65100),
      CampaignType.print => const Color(0xFF2E7D32),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        type.label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.secondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _ContentText extends StatelessWidget {
  final String text;
  const _ContentText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        height: 1.5,
        color: AppColors.primaryDark,
      ),
    );
  }
}

class _SubField extends StatelessWidget {
  final String label;
  final String content;
  const _SubField({required this.label, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              content,
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: AppColors.primaryDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
