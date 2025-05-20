import 'package:flutter/material.dart';
import '../services/file_service.dart';
import '../services/auth_service.dart';
import '../core/network/dio_client.dart';
import '../models/file_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FilesView extends StatefulWidget {
  const FilesView({super.key});

  @override
  State<FilesView> createState() => _FilesViewState();
}

class _FilesViewState extends State<FilesView> {
  late FileService _fileService;
  bool _isLoading = false;
  String? _errorMessage;
  List<FileModel> _files = [];

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _loadFiles();
  }

  void _initializeServices() {
    final storage = const FlutterSecureStorage();
    final dioClient = DioClient(storage: storage);
    final authService = AuthService(
      dioClient: dioClient,
      storage: storage,
      isDebugMode: true,
    );
    _fileService = FileService(
      dioClient: dioClient,
      storage: storage,
      authService: authService,
      isDebugMode: true,
    );
  }

  Future<void> _loadFiles() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final files = await _fileService.getAllFiles();
      setState(() {
        _files = files;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _addFile() async {
    // TODO: Implement add file functionality
  }

  Future<void> _deleteFile(String id) async {
    try {
      await _fileService.deleteFile(id);
      await _loadFiles();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Files'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addFile,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : ListView.builder(
                  itemCount: _files.length,
                  itemBuilder: (context, index) {
                    final file = _files[index];
                    return ListTile(
                      title: Text(file.name),
                      subtitle: Text(file.type),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteFile(file.id),
                      ),
                    );
                  },
                ),
    );
  }
}
