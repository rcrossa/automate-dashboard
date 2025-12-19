import 'package:flutter/material.dart';
import 'package:msasb_app/domain/entities/conversation_segment.dart';
import 'package:intl/intl.dart';

/// Widget para mostrar la timeline de una conversación con speakers
class ConversationTimeline extends StatelessWidget {
  final List<ConversationSegment> segments;
  final List<Participant>? participants;

  const ConversationTimeline({
    super.key,
    required this.segments,
    this.participants,
  });

  @override
  Widget build(BuildContext context) {
    if (segments.isEmpty) {
      return const Center(
        child: Text('No hay segmentos de conversación'),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: segments.length,
      itemBuilder: (context, index) {
        final segment = segments[index];
        final participant = participants?.firstWhere(
          (p) => p.speakerId == segment.speaker,
          orElse: () => Participant(
            speakerId: segment.speaker,
            role: segment.role ?? 'desconocido',
          ),
        );

        return _buildSegmentCard(context, segment, participant);
      },
    );
  }

  Widget _buildSegmentCard(
    BuildContext context,
    ConversationSegment segment,
    Participant? participant,
  ) {
    // Use role from segment directly (backend doesn't send participants list)
    final isEjecutivo = segment.role == 'ejecutivo';
    final speakerName = isEjecutivo ? 'Ejecutivo' : 'Cliente';
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          SizedBox(
            width: 60,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: isEjecutivo 
                      ? Colors.blue.shade600 
                      : Colors.green.shade600,
                  child: Icon(
                    isEjecutivo ? Icons.person : Icons.person_outline,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTimestamp(segment.start),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          // Message bubble
          Expanded(
            child: Card(
              elevation: 1,
              margin: const EdgeInsets.only(left: 8),
              color: isEjecutivo 
                  ? Colors.blue.shade50 
                  : Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          speakerName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isEjecutivo 
                                ? Colors.blue.shade800 
                                : Colors.green.shade800,
                            fontSize: 13,
                          ),
                        ),
                        const Spacer(),
                        if (segment.confidence != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _getConfidenceColor(segment.confidence!),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${(segment.confidence! * 100).toStringAsFixed(0)}%',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      segment.text,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(double seconds) {
    final duration = Duration(seconds: seconds.toInt());
    final minutes = duration.inMinutes;
    final secs = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.9) return Colors.green;
    if (confidence >= 0.7) return Colors.orange;
    return Colors.red;
  }
}
