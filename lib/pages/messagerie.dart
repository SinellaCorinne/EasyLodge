import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../composants/messages.dart';
import '../style.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  String _selectedFilter = 'Tous';
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Messages et Support'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Iconsax.message_add, color: KColors.primary),
            onPressed: () => _composeMessage(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          _buildMessageStatsCards(),
          Expanded(child: _buildMessagesList()),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;

    return Container(
      padding: EdgeInsets.all(isDesktop ? 24 : 16),
      color: Colors.white,
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Rechercher dans les messages...',
              prefixIcon: const Icon(Iconsax.search_normal),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
          SizedBox(height: isDesktop ? 20 : 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedFilter,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                  items: ['Tous', 'Non lu', 'Lu', 'Répondu', 'Urgent']
                      .map((filter) => DropdownMenuItem(
                    value: filter,
                    child: Text(filter),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedFilter = value!;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageStatsCards() {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;

    return Container(
      padding: EdgeInsets.all(isDesktop ? 24 : 16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard('45', 'Total', KColors.primary),
          ),
          SizedBox(width: isDesktop ? 24 : 12),
          Expanded(
            child: _buildStatCard('12', 'Non lus', Colors.red),
          ),
          SizedBox(width: isDesktop ? 24 : 12),
          Expanded(
            child: _buildStatCard('8', 'Urgents', Colors.orange),
          ),
          SizedBox(width: isDesktop ? 24 : 12),
          Expanded(
            child: _buildStatCard('25', 'Répondus', Colors.green),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    List<Map<String, dynamic>> filteredMessages = _getFilteredMessages();
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredMessages.length,
      itemBuilder: (context, index) {
        final message = filteredMessages[index];
        return _buildMessageCard(message);
      },
    );
  }

  Widget _buildMessageCard(Map<String, dynamic> message) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;

    Color statusColor = _getStatusColor(message['statut']);
    Color priorityColor = _getPriorityColor(message['priorite']);

    return Card(
      margin: EdgeInsets.only(bottom: isDesktop ? 16 : 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _openMessageDetail(message),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(isDesktop ? 24 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: KColors.primary.withOpacity(0.1),
                    child: const Icon(Iconsax.user, color: KColors.primary),
                  ),
                  SizedBox(width: isDesktop ? 24 : 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message['expediteur'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          message['sujet'],
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          message['statut'],
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: priorityColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          message['priorite'],
                          style: TextStyle(
                            color: priorityColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: isDesktop ? 20 : 12),
              Text(
                message['message'],
                style: TextStyle(color: Colors.grey.shade700),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: isDesktop ? 20 : 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Iconsax.calendar, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(
                        message['date'],
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      ),
                      const SizedBox(width: 12),
                      
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Iconsax.message_text, size: 20),
                        onPressed: () => _replyToMessage(message),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Iconsax.more, size: 20),
                        onPressed: () => _showMessageOptions(message),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Non lu':
        return Colors.red;
      case 'Lu':
        return Colors.blue;
      case 'Répondu':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Urgent':
        return Colors.red;
      case 'High':
        return Colors.orange;
      case 'Normal':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  List<Map<String, dynamic>> _getFilteredMessages() {
    List<Map<String, dynamic>> filtered = messages;
    if (_selectedFilter != 'Tous') {
      filtered = filtered.where((message) {
        if (_selectedFilter == 'Urgent') {
          return message['priorite'] == 'Urgent';
        }
        return message['statut'] == _selectedFilter;
      }).toList();
    }
    if (_searchController.text.isNotEmpty) {
      String searchTerm = _searchController.text.toLowerCase();
      filtered = filtered.where((message) {
        return message['expediteur'].toLowerCase().contains(searchTerm) ||
            message['sujet'].toLowerCase().contains(searchTerm) ||
            message['message'].toLowerCase().contains(searchTerm);
      }).toList();
    }
    return filtered;
  }

  void _composeMessage() {
    print('Composer un nouveau message');
  }

  void _openMessageDetail(Map<String, dynamic> message) {
    print('Ouvrir le message: ${message['id']}');
  }

  void _replyToMessage(Map<String, dynamic> message) {
    print('Répondre au message: ${message['id']}');
  }

  void _showMessageOptions(Map<String, dynamic> message) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Iconsax.message_text),
              title: const Text('Répondre'),
              onTap: () {
                Navigator.pop(context);
                _replyToMessage(message);
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.archive),
              title: const Text('Archiver'),
              onTap: () {
                Navigator.pop(context);
                _archiveMessage(message);
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.trash, color: Colors.red),
              title: const Text('Supprimer', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _deleteMessage(message);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _archiveMessage(Map<String, dynamic> message) {
    print('Archiver le message: ${message['id']}');
  }

  void _deleteMessage(Map<String, dynamic> message) {
    print('Supprimer le message: ${message['id']}');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
