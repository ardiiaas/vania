import 'package:join_vania/app/models/customer.dart'; // Adjust the import to your actual model location
import 'package:vania/vania.dart';

class CustomerController extends Controller {
  /// Membuat customer baru
  Future<Response> create(Request request) async {
    request.validate({
      'cust_name': 'required',
      'cust_address': 'required',
      'cust_city': 'required',
      'cust_state': 'required',
      'cust_zip': 'required',
      'cust_country': 'required',
      'cust_telp': 'required',
    }, {
      'cust_name.required': 'Nama pelanggan tidak boleh kosong.',
      'cust_address.required': 'Alamat tidak boleh kosong.',
      'cust_city.required': 'Kota tidak boleh kosong.',
      'cust_state.required': 'Provinsi tidak boleh kosong.',
      'cust_zip.required': 'Kode pos tidak boleh kosong.',
      'cust_country.required': 'Negara tidak boleh kosong.',
      'cust_telp.required': 'Telepon tidak boleh kosong.',
    });

    final requestData = request.input();
    requestData['created_at'] = DateTime.now().toIso8601String();

    // Cek apakah customer sudah ada berdasarkan telepon
    final existingCustomer = await Customer()
        .query()
        .where('cust_telp', '=', requestData['cust_telp'])
        .first();
    if (existingCustomer != null) {
      return Response.json(
        {
          "message": "Pelanggan sudah ada.",
        },
        409,
      );
    }

    // Simpan customer baru ke dalam database
    await Customer().query().insert(requestData);

    return Response.json({
      "message": "Pelanggan berhasil ditambahkan.",
      "data": requestData,
    }, 201);
  }

  Future<Response> show(Request request) async {
    try {
      // Ambil semua data pelanggan dari database
      final customers = await Customer().query().get();

      // Pastikan data pelanggan diformat dengan benar
      final formattedCustomers = customers.map((customer) {
        return {
          'cust_id': customer['cust_id'] ?? 0,
          'cust_name': customer['cust_name'] ?? '',
          'cust_address': customer['cust_address'] ?? '',
          'cust_city': customer['cust_city'] ?? '',
          'cust_state': customer['cust_state'] ?? '',
          'cust_zip': customer['cust_zip'] ?? '',
          'cust_country': customer['cust_country'] ?? '',
          'cust_telp': customer['cust_telp'] ?? '',
          'created_at': customer['created_at']?.toIso8601String() ?? '',
          'updated_at': customer['updated_at']?.toIso8601String() ?? '',
        };
      }).toList();

      // Kirimkan respons JSON yang diformat
      return Response.json({
        'message': 'Daftar Customer',
        'data': formattedCustomers,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat mengambil data.',
        'error': e.toString(),
      }, 500);
    }
  }

  // Future<Response> show() async {
  //   final customers = await Customer().query().get();

  //   final responseData = {
  //     "message": "Daftar pelanggan",
  //     "data": customers.isNotEmpty ? customers : {},
  //   };

  //   // Return the response directly as JSON
  //   return Response.json(responseData, 200);
  // }

  /// Memperbarui data customer berdasarkan cust_id
  Future<Response> update(Request request, int cust_id) async {
    // Validasi input dari pengguna
    request.validate({
      'cust_name': 'required',
      'cust_address': 'required',
      'cust_city': 'required',
      'cust_state': 'required',
      'cust_zip': 'required',
      'cust_country': 'required',
      'cust_telp': 'required',
    }, {
      'cust_name.required': 'Nama pelanggan tidak boleh kosong.',
      'cust_address.required': 'Alamat tidak boleh kosong.',
      'cust_city.required': 'Kota tidak boleh kosong.',
      'cust_state.required': 'Provinsi tidak boleh kosong.',
      'cust_zip.required': 'Kode pos tidak boleh kosong.',
      'cust_country.required': 'Negara tidak boleh kosong.',
      'cust_telp.required': 'Telepon tidak boleh kosong.',
    });

    final requestData = request.input();
    requestData['updated_at'] = DateTime.now().toIso8601String();

    // Update data customer di database menggunakan cust_id
    final affectedRows = await Customer()
        .query()
        .where('cust_id', '=', cust_id)
        .update(requestData);
    if (affectedRows == 0) {
      return Response.json({
        "message": "Pelanggan dengan cust_id $cust_id tidak ditemukan.",
      }, 404);
    }

    return Response.json({
      "message": "Pelanggan berhasil diperbarui.",
      "data": requestData,
    }, 200);
  }

  /// Menghapus customer berdasarkan ID
  Future<Response> destroy(int id) async {
    final affectedRows =
        await Customer().query().where('cust_id', '=', id).delete();
    if (affectedRows == 0) {
      return Response.json({
        "message": "Pelanggan dengan ID $id tidak ditemukan.",
      }, 404);
    }

    return Response.json({
      "message": "Pelanggan berhasil dihapus.",
    }, 200);
  }
}

final CustomerController customerController = CustomerController();
