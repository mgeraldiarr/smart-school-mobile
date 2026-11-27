# Model pengenalan wajah

| File | Keterangan |
|---|---|
| `mobilefacenet.tflite` | MobileFaceNet (TensorFlow Lite). Input wajah 112×112 RGB, output embedding wajah. |
| `LICENSE-mobilefacenet.txt` | Lisensi BSD-3-Clause dari pembuat model. **Wajib ikut disertakan** selama model ini dipakai. |

- Sumber: https://github.com/MCarlomagno/FaceRecognitionAuth (`assets/mobilefacenet.tflite`)
- Lisensi: BSD 3-Clause, Copyright (c) 2020, Marcos Carlomagno
- SHA-256: `be4bc7cfc53f7bc336d0f28b1ab92535f618c913a422b683210750f6b5354854`

Embedding yang tersimpan di server hanya bisa dibandingkan dengan embedding dari
**model yang sama**. Kalau file ini diganti, naikkan `model_version` (lihat
`docs/API_CONTRACT.md` di repo backend) dan semua siswa harus mendaftarkan wajah ulang.
