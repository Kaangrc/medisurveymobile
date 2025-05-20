import 'package:flutter/material.dart';
import '../services/form_service.dart';
import '../core/network/dio_client.dart';
import '../models/form_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../widgets/custom_drawer.dart';

class FormsView extends StatefulWidget {
  const FormsView({super.key});

  @override
  State<FormsView> createState() => _FormsViewState();
}

class _FormsViewState extends State<FormsView> {
  bool _isLoading = false;
  String? _errorMessage;
  List<FormModel> _forms = [];

  late final FormService _formService;

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _loadForms();
  }

  void _initializeServices() {
    final storage = const FlutterSecureStorage();
    final dioClient = DioClient(storage: storage);
    _formService = FormService(
      dioClient: dioClient,
      storage: storage,
      isDebugMode: true,
    );
  }

  Future<void> _loadForms() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final forms = await _formService.getAllForms();
      setState(() {
        _forms = forms;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Formlar yüklenirken bir hata oluştu';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleAddForm() async {
    final result = await Navigator.pushNamed(context, '/add-form');
    if (result == true) {
      _loadForms();
    }
  }

  Future<void> _handleDeleteForm(String formId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Form Sil'),
        content: const Text('Bu formu silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sil'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _formService.deleteForm(formId);
      if (result['status'] == 'success') {
        _loadForms();
      } else {
        setState(() {
          _errorMessage = result['message'];
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Form silinirken bir hata oluştu';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formlar'),
      ),
      drawer: const CustomDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadForms,
                        child: const Text('Tekrar Dene'),
                      ),
                    ],
                  ),
                )
              : _forms.isEmpty
                  ? const Center(child: Text('Henüz form bulunmuyor'))
                  : RefreshIndicator(
                      onRefresh: _loadForms,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: _forms.length,
                        itemBuilder: (context, index) {
                          final form = _forms[index];
                          return Card(
                            child: ListTile(
                              title: Text(form.title),
                              subtitle: Text(form.description),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _handleDeleteForm(form.id),
                              ),
                              onTap: () => Navigator.pushNamed(
                                context,
                                '/form-details',
                                arguments: form,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}
