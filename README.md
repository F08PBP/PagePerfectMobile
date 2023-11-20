# Proyek Akhir Semester Tahap 1

**Nama Anggota Kelompok F08**
* Arya Lesmana - 2206081603
* Muhammad Yusuf Haikal - 2206081490
* Rizvanu Satrio Nugroho - 2206823682
* Nanda Nathaniela Meizari - 2206824136
* Muhamad Hanif Nurrifky Wicaksono - 2206818846


## Penjelasan aplikasi, alur aplikasi, dan manfaat
“PagePerfect” merupakan aplikasi jual-beli buku. Di dalamnya terdapat tiga jenis user yang berbeda. Ada Member yang bisa membeli buku, Penulis yang bisa mempublish buku baru, dan Karyawan yang meneruskan buku-buku dari penulis ke member.

Pada awal masuk ke aplikasi, user akan tiba di landing page yang di halaman tersebut terdapat fitur Login/Register dan beberapa rekomendasi buku. Kemudian user bisa login jika sudah memiliki akun atau register jika belum memiliki akun. 

(Member)
Pada saat baru login, member akan tiba pada landing page member yang terdapat buku yang telah dibeli, beberapa rekomendasi buku dan fitur search untuk mencari buku yang diinginkan. Pada NavBar, terdapat beberapa page seperti e-wallet, achievement, dan keranjang. 

(Writer)
Pada saat baru login, writer akan tiba pada landing page yang menampilkan buku yang sudah ia publish dan revenue yang ia dapatkan.

(Employee)
Pada saat baru login, employee akan tiba di landing page employee yang terdapat katalog buku yang tersedia dan juga akan ada modul menerima/menolak publikasi buku dari writer serta memasukkan buku ke katalog

PagePerfect memiliki manfaat sebagai berikut :
Menambah minat baca masyarakat dengan mudah membeli buku secara online, menambah minat menulis bagi masyarakat dengan mudah melakukan publishing buku secara online, dan dapat mengetahui buku - buku yang bagus untuk dibaca dengan rekomendasi dari website.

## Penjelasan branding dari aplikasi
Website akan dibuat secara modern dengan dominasi color palette biru dan putih, tampilan akan mirip-mirip dengan bookstore online yang sudah ada. Tampilan styling website akan menggunakan Bootstrap. 

## Penjelasan model Buku + Dataset
Dataset buku akan diambil dari kaggle (https://www.kaggle.com/datasets/imtkaggleteam/book-recommendation-good-book-api) dan setiap buku akan memiliki atribut sebagai berikut:


| Atribut       | Penjelasan                               |
| ------------- | ---------------------------------------- |
| ID            | Id unik tiap buku agar mudah dicari      |
| Title         | Judul buku                               |
| Author        | Penulis/writer                          |
| Num Pages     | Jumlah halaman buku                     |

## Penjelasan modul - modul umum
| Modul               | Penjelasan                                                                   |
| ------------------- | ---------------------------------------------------------------------------- |
| Register            | Modul untuk mendaftarkan user baru ke web. Saat melakukan registrasi, user diberikan opsi untuk memilih role sebagai Member, Writer, atau Employee. |
| Login               | Modul untuk login ke web, dengan role user sesuai dengan pilihannya saat registrasi (Member, Writer, atau Employee). |
| Rekomendasi Buku    | User yang masuk ke landing page web tetapi belum menjadi Member akan diberikan beberapa rekomendasi buku untuk menarik minat mereka. |

## Penjelasan modul - modul Member
| Modul                | Penjelasan                                                                   |
| -------------------- | ---------------------------------------------------------------------------- |
| Buku dibeli          | Member dapat melihat daftar buku yang telah dibeli sebelumnya.             |
| Recommendation Buku  | Menampilkan kumpulan buku yang direkomendasikan kepada user berdasarkan genre yang paling banyak dibeli oleh member atau rating yang tinggi. |
| E-Wallet            | Sistem pembayaran pada website yang memungkinkan member untuk melakukan top up dan mengecek saldo di tab E-Wallet. |
| Keranjang            | Member dapat memasukkan buku yang ingin dibeli ke dalam keranjang sehingga dapat melakukan checkout nanti. |


## Penjelasan modul - modul Writer
| Modul          | Penjelasan                                                                   |
| --------------- | ---------------------------------------------------------------------------- |
| Publish Buku   | Writer dapat mempublish buku baru yang tidak ada di katalog buku sebelumnya. |
| Published Books | Writer dapat melihat berbagai buku-buku yang sudah ia publish sebelumnya.   |
| Status Page    | Buku yang dipublish oleh writer tidak langsung muncul di halaman member. Harus menunggu status penerimaan dari karyawan agar bisa terlihat pada halaman member. Pada halaman ini, writer dapat melihat status dari buku yang baru ia publish, seperti sudah diterima atau ditolak. |
| Revenue        | Writer dapat melihat pendapatan dari buku-buku yang telah ia publish dan telah dibeli oleh member. |

## Penjelasan modul - modul Employee
| Modul                            | Penjelasan                                                                   |
| --------------------------------- | ---------------------------------------------------------------------------- |
| Katalog Buku                     | Menampilkan informasi mengenai buku yang tersedia dalam toko buku beserta dengan jumlah yang tersedia dan jumlah yang sudah terjual. |
| Memasukkan Buku Ke Katalog       | Karyawan dapat memilih buku yang akan ditampilkan dalam katalog toko buku, yang akan diperlihatkan kepada member toko buku. |
| Menerima / Menolak Buku Dari Writer | Ketika seorang writer mempublish buku, buku tersebut akan dikirim ke karyawan terlebih dahulu. Karyawan kemudian dapat menerima atau menolak buku yang telah dikirim oleh publisher. Buku yang diterima kemudian dapat dimasukkan ke dalam katalog toko buku. |

## Pembagian tugas pengerjaan modul - modul
Adapun pembagian tugas dalam pengerjaan modul - modul yang diperlukan adalah sebagai berikut :

**1. Muhamad Hanif Nurrifky Wicaksono**

Tampilan dan modul umum + model dan dataset

**2. Nanda Nathaniela Meizari**

Tampilan dan modul Employee

**3. Arya Lesmana**

Tampilan dan modul Writer

**4. Rizvanu Satrio Nugroho**

Tampilan dan modul member (buku dibeli, rekomendasi, landing page untuk member)

**5. Muhammad Yusuf Haikal**

Tampilan dan modul member (e-wallet, keranjang)

## Berita Acara
https://docs.google.com/spreadsheets/d/1Su2OBkcqqKxYDrN0p_m3vsAfPzEv0vd5dwr02b05mYI/edit#gid=0
