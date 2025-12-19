// Centralized finance data for the app
class FinanceData {
  // Current user's financial summary - calculated dynamically
  static Map<String, dynamic> getSummary() {
    final bills = getBills();

    // Calculate totals
    int totalBillsValue = 0;
    int totalPaidValue = 0;
    int totalUnpaidValue = 0;

    for (final bill in bills) {
      final amount = bill['amountValue'] as int? ?? 0;
      totalBillsValue += amount;

      if (bill['status'] == 'lunas') {
        totalPaidValue += amount;
      } else {
        totalUnpaidValue += amount;
      }
    }

    // Calculate progress (paid / total)
    double progress = totalBillsValue > 0
        ? totalPaidValue / totalBillsValue
        : 0.0;
    int progressPercentage = (progress * 100).round();

    // Format currency
    String formatCurrency(int value) {
      String valueStr = value.toString();
      String result = '';
      int count = 0;
      for (int i = valueStr.length - 1; i >= 0; i--) {
        count++;
        result = valueStr[i] + result;
        if (count % 3 == 0 && i != 0) {
          result = '.' + result;
        }
      }
      return 'Rp $result';
    }

    return {
      'totalUnpaid': formatCurrency(totalUnpaidValue),
      'totalUnpaidValue': totalUnpaidValue,
      'totalPaid': formatCurrency(totalPaidValue),
      'totalPaidValue': totalPaidValue,
      'totalBills': formatCurrency(totalBillsValue),
      'totalBillsValue': totalBillsValue,
      'paymentProgress': progress,
      'progressPercentage': '$progressPercentage%',
    };
  }

  // All bills (tagihan)
  static List<Map<String, dynamic>> getBills() {
    return [
      {
        'id': 'BILL001',
        'title': 'SPP Semester Ganjil 2024/2025',
        'type': 'SPP',
        'semester': '5 (Ganjil)',
        'dueDate': '15 Des 2024',
        'amount': 'Rp 7.500.000',
        'amountValue': 7500000,
        'status': 'belum_lunas',
        'statusText': 'Belum Lunas',
        'vaNumber': '8888 0123 2023010123',
      },
      {
        'id': 'BILL002',
        'title': 'UKT Semester Genap 2023/2024',
        'type': 'UKT',
        'semester': '4 (Genap)',
        'dueDate': '02 Desember 2024',
        'amount': 'Rp 7.500.000',
        'amountValue': 7500000,
        'status': 'lunas',
        'statusText': 'Sudah Lunas',
        'paymentMethod': 'Virtual Account BCA',
        'paymentDate': '02 Des 2024, 14:28 WIB',
        'referenceNumber': 'TRX-2024120214280123',
        'proofFileName': 'Bukti_Transfer_UKT.jpg',
        'proofUploadDate': '02 Des 2024, 14:30 WIB',
      },
    ];
  }

  // Payment history (riwayat)
  static List<Map<String, dynamic>> getPaymentHistory() {
    return [
      {
        'id': 'PAY001',
        'title': 'Pembayaran Berhasil',
        'subtitle': 'UKT Semester Ganjil 2024/2025',
        'billType': 'Pembayaran UKT Semester Ganjil 2024/2025',
        'semester': '5 - Ganjil 2024/2025',
        'dueDate': '02 Desember 2024',
        'amount': 'Rp 7.500.000',
        'status': 'success',
        'paymentMethod': 'Virtual Account BCA',
        'paymentDate': '02 Des 2024, 14:28 WIB',
        'referenceNumber': 'TRX-2024120214280123',
        'proofFileName': 'Bukti_Transfer_UKT.jpg',
        'proofUploadDate': '02 Des 2024, 14:30 WIB',
      },
      {
        'id': 'PAY002',
        'title': 'Pembayaran Berhasil',
        'subtitle': 'Cicilan SPP #2',
        'billType': 'Cicilan SPP Semester Ganjil 2024/2025',
        'semester': '5 - Ganjil 2024/2025',
        'dueDate': '28 November 2024',
        'amount': 'Rp 2.500.000',
        'status': 'success',
        'paymentMethod': 'Tunai / Cash',
        'paymentDate': '28 Nov 2024, 10:15 WIB',
        'referenceNumber': 'TRX-2024112810150456',
        'proofFileName': 'Bukti_Cicilan_SPP_2.jpg',
        'proofUploadDate': '28 Nov 2024, 10:20 WIB',
      },
      {
        'id': 'PAY003',
        'title': 'Pembayaran Berhasil',
        'subtitle': 'Cicilan SPP #1',
        'billType': 'Cicilan SPP Semester Ganjil 2024/2025',
        'semester': '5 - Ganjil 2024/2025',
        'dueDate': '15 November 2024',
        'amount': 'Rp 2.500.000',
        'status': 'success',
        'paymentMethod': 'Virtual Account BCA',
        'paymentDate': '15 Nov 2024, 09:45 WIB',
        'referenceNumber': 'TRX-2024111509450789',
        'proofFileName': 'Bukti_Cicilan_SPP_1.jpg',
        'proofUploadDate': '15 Nov 2024, 09:50 WIB',
      },
      {
        'id': 'PAY004',
        'title': 'Pembayaran Diproses',
        'subtitle': 'UAS Semester Genap 2023/2024',
        'billType': 'Biaya UAS',
        'semester': '4 (Genap)',
        'dueDate': '20 Des 2024',
        'amount': 'Rp 500.000',
        'status': 'processing',
        'vaNumber': '8888 0123 2023010124',
      },
    ];
  }

  // Finance notifications
  static List<Map<String, dynamic>> getNotifications() {
    return [
      {
        'id': 'NOTIF001',
        'type': 'warning',
        'title': 'Tagihan SPP Semester Ganjil',
        'subtitle': 'Jatuh tempo dalam 5 hari',
        'amount': 'Rp 7.500.000',
        'billId': 'BILL001',
      },
      {
        'id': 'NOTIF002',
        'type': 'info',
        'title': 'Pembayaran UKT Berhasil',
        'subtitle': 'Terverifikasi sistem\n2 Des 2024',
        'amount': null,
        'paymentId': 'PAY001',
      },
      {
        'id': 'NOTIF003',
        'type': 'success',
        'title': 'Cicilan Ke-2 Diterima',
        'subtitle': 'Terima kasih atas pembayaran\n28 Nov 2024',
        'amount': null,
        'paymentId': 'PAY002',
      },
    ];
  }

  // Get bill by ID
  static Map<String, dynamic>? getBillById(String id) {
    return getBills().firstWhere((bill) => bill['id'] == id, orElse: () => {});
  }

  // Get payment by ID
  static Map<String, dynamic>? getPaymentById(String id) {
    return getPaymentHistory().firstWhere(
      (payment) => payment['id'] == id,
      orElse: () => {},
    );
  }

  // Get unpaid bills
  static List<Map<String, dynamic>> getUnpaidBills() {
    return getBills().where((bill) => bill['status'] == 'belum_lunas').toList();
  }

  // Get paid bills
  static List<Map<String, dynamic>> getPaidBills() {
    return getBills().where((bill) => bill['status'] == 'lunas').toList();
  }
}

