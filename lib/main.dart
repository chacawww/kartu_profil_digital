ElevatedButton.icon(
  onPressed: () => bukaForm(context),
  icon: const Icon(Icons.edit),
  label: const Text('Edit Profil'),
),

const SizedBox(height: 10),

OutlinedButton.icon(
  onPressed: () async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Profil?'),
        content: const Text(
          'Data profil akan dikembalikan ke pengaturan awal.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (konfirmasi == true) {
      onReset();
    }
  },
  icon: const Icon(Icons.refresh),
  label: const Text('Reset Profil'),
),