select * from thongTinCaNhan;
select * from film;
select * from studio;
select * from daoDien;
select * from phanLoaiDoTuoi;
select * from nhanVat;

-- 1. Liệt kê tên tất cả các bộ phim.
-- RA: π_tenFilm(Film)
select f.tenFilm from film f;

-- 2. Tìm thông tin tất cả các đạo diễn (họ, tên) trong cơ sở dữ liệu.
-- RA: π_IDCaNhan,ho,ten(σ_IDCaNhan∈(π_IDDaoDien(daoDien))(thongTinCaNhan))
select ttcn.IDCaNhan, ttcn.ho || ' ' || ttcn.ten as ho_va_ten_dao_dien
from thongTinCaNhan ttcn
where ttcn.IDCaNhan in (select distinct dd.IDDaoDien from daoDien dd);

-- 3. Đếm số lượng phim mà mỗi studio đã sản xuất.
-- RA: studio ⨝ film → γ_studioID,tenStudio; count(*)(film)
select s.studioID, s.tenStudio, count(*) as so_luong_phim
from studio s join film f on s.studioID = f.studioID
group by s.studioID, s.tenStudio;

-- 4. Liệt kê các bộ phim có rating từ 8 trở lên.
-- RA: π_IDFilm,tenFilm,rating(σ_rating≥8(Film))
select f.IDFilm, f.tenFilm, f.rating from film f where f.rating >= 8;

-- 5. Liệt kê các diễn viên từng đóng trong các phần Harry Potter
-- RA: π_IDCaNhan,ho,ten,tenNhanVat((thongTinCaNhan ⨝ nhanVat ⨝ film) ∧ tenFilm LIKE '%harry potter%')
select distinct ttcn.IDCaNhan, ttcn.ho || ' ' || ttcn.ten as ho_va_ten, nv.tenNhanVat
from thongTinCaNhan ttcn
    join nhanVat nv on ttcn.IDCaNhan = nv.IDDienVien
    join film f on nv.IDFilm = f.IDFilm
where lower(f.tenFilm) like '%harry potter%';

-- 6. Liệt kê tên phim, ngày phát hành và tên studio sản xuất phim đó.
-- RA: π_IDFilm,tenFilm,ngayPhatHanh,tenStudio(film ⨝ studio)
select f.IDFilm, f.tenFilm, f.ngayPhatHanh, s.tenStudio
from film f join studio s on f.studioID = s.studioID;

-- 7. Liệt kê tất cả các nhân vật cùng với tên phim mà họ xuất hiện.
-- RA: π_tenNhanVat,tenFilm(nhanVat ⨝ film)
select nv.tenNhanVat, f.tenFilm
from nhanVat nv join film f on nv.IDFilm = f.IDFilm;

-- 8. Tìm các diễn viên đã đóng trong nhiều hơn 2 phim khác nhau.
-- RA: γ_IDCaNhan; count(distinct IDFilm) > 2(thongTinCaNhan ⨝ nhanVat ⨝ film)
select ttcn.IDCaNhan, count(distinct f.IDFilm) as so_luong_phim_da_dong
from thongTinCaNhan ttcn
    join nhanVat nv on ttcn.IDCaNhan = nv.IDDienVien
    join film f on nv.IDFilm = f.IDFilm
group by ttcn.IDCaNhan
having count(distinct f.IDFilm) > 2;

-- 9. Liệt kê tất cả các đạo diễn và số lượng phim mà họ đã đạo diễn.
-- RA: γ_IDCaNhan,ho,ten; count(IDFilm)(thongTinCaNhan ⨝ daoDien)
select ttcn.IDCaNhan, ttcn.ho || ' ' || ttcn.ten as ho_va_ten_dao_dien, count(dd.IDFilm) as so_luong_phim_dao_dien
from thongTinCaNhan ttcn
    join daoDien dd on ttcn.IDCaNhan = dd.IDDaoDien
group by ttcn.IDCaNhan, ttcn.ho, ttcn.ten;

-- 10. Liệt kê các phim có doanh thu lớn hơn 100 triệu USD.
-- RA: π_IDFilm,tenFilm,doanhThu(σ_doanhThu>100000000(Film))
select f.IDFilm, f.tenFilm, f.doanhThu
from film f
where f.doanhThu > 100000000;

-- 11. Liệt kê các phim được phát hành sau năm 2020.
-- RA: π_IDFilm,tenFilm,ngayPhatHanh(σ_ngayPhatHanh>'31/12/2020'(Film))
select f.IDFilm, f.tenFilm, f.ngayPhatHanh
from film f
where to_date(f.ngayPhatHanh, 'DD/MM/YYYY') > to_date('31/12/2020', 'DD/MM/YYYY');

-- 12. Liệt kê các studio sản xuất phim có rating trung bình từ 8.5 trở lên.
-- RA: γ_studioID,tenStudio; avg(rating) >= 8.5(studio ⨝ film)
select s.studioID, s.tenStudio, round(avg(f.rating), 2) as avg_rating
from studio s
    join film f on s.studioID = f.studioID
group by s.studioID, s.tenStudio
having avg(f.rating) >= 8.5;

-- 13. Liệt kê các diễn viên nữ trong cơ sở dữ liệu.
-- RA: π_IDCaNhan,ho,ten,gioiTinh(σ_gioiTinh='female'(thongTinCaNhan))
select ttcn.IDCaNhan, ttcn.ho || ' ' || ttcn.ten as ho_va_ten, ttcn.gioiTinh
from thongTinCaNhan ttcn
where lower(ttcn.gioiTinh) in ('f', 'female');

-- 14. Liệt kê các phim thuộc thể loại 'Action'.
-- RA: π_IDFilm,tenFilm,theLoai(σ_theLoai LIKE '%action%'(Film))
select f.IDFilm, f.tenFilm, f.theLoai
from film f
where lower(f.theLoai) like '%action%';

-- 15. Liệt kê các phim có thời lượng lớn hơn 120 phút.
-- RA: π_IDFilm,tenFilm,thoiLuong(σ_thoiLuong>120(Film))
select f.IDFilm, f.tenFilm, f.thoiLuong
from film f
where f.thoiLuong > 120;

-- 16. Thời lượng trung bình của các phim có rating >= 8, không tính tv series
-- RA: avg(thoiLuong)(σ_rating>=8 ∧ theLoai NOT LIKE '%tv series%'(Film))
select round(avg(f.thoiLuong), 2) as thoi_luong_trung_binh
from film f
where f.rating >= 8
  and lower(f.theLoai) not like '%tv series%';
