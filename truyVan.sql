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

-- 17. Tính tỉ lệ rating trên mỗi phút của các phim (không tính tv series)
-- RA: π_IDFilm,tenFilm,rating,thoiLuong,rating/thoiLuong(σ_theLoai NOT LIKE '%tv series%'(Film))
select f.IDFilm, f.tenFilm, f.rating, f.thoiLuong, 
       round(f.rating / f.thoiLuong, 3) as rating_per_minute
from film f
where lower(f.theLoai) not like '%tv series%';

-- 18. Liệt kê các phim có nhiều hơn 3 diễn viên tham gia.
-- RA: γ_IDFilm; count(IDCaNhan)>3(nhanVat)
select nv.IDFilm, count(nv.IDDienVien) as so_dien_vien
from nhanVat nv
group by nv.IDFilm
having count(nv.IDDienVien) > 3;

-- 19. Liệt kê các phim có ít hơn 2 đạo diễn.
-- RA: γ_IDFilm; count(IDDaoDien)<2(daoDien)
select dd.IDFilm, count(dd.IDDaoDien) as so_dao_dien
from daoDien dd
group by dd.IDFilm
having count(dd.IDDaoDien) < 2;

-- 20. Liệt kê các phim có phân loại độ tuổi là 'PG-13'.
-- RA: π_IDFilm,tenFilm(σ_IDPhanLoai='PG-13'(film))
select f.IDFilm, f.tenFilm
from film f
    join phanLoaiDoTuoi pldt on f.IDPhanLoai = pldt.IDPhanLoai
where pldt.tenPhanLoai = 'PG-13';

-- 21. Liệt kê các diễn viên đã từng đóng vai chính.
-- RA: π_IDCaNhan,ho,ten(σ_vaiChinh=1(nhanVat ⨝ thongTinCaNhan))
select distinct ttcn.IDCaNhan, ttcn.ho || ' ' || ttcn.ten as ho_va_ten
from thongTinCaNhan ttcn
    join nhanVat nv on ttcn.IDCaNhan = nv.IDDienVien
where nv.vaiChinh = 1;

-- 22. Liệt kê các phim có ít nhất 1 diễn viên nữ đóng vai chính.
-- RA: π_IDFilm(σ_gioiTinh='female' ∧ vaiChinh=1(thongTinCaNhan ⨝ nhanVat))
select distinct nv.IDFilm
from nhanVat nv
    join thongTinCaNhan ttcn on nv.IDDienVien = ttcn.IDCaNhan
where lower(ttcn.gioiTinh) in ('f', 'female') and nv.vaiChinh = 1;

-- 23. Liệt kê các phim có tổng doanh thu lớn nhất.
-- RA: π_IDFilm,tenFilm,doanhThu(σ_doanhThu=max(doanhThu)(film))
select f.IDFilm, f.tenFilm, f.doanhThu
from film f
where f.doanhThu = (select max(doanhThu) from film);

-- 24. Liệt kê các phim có rating thấp nhất.
-- RA: π_IDFilm,tenFilm,rating(σ_rating=min(rating)(film))
select f.IDFilm, f.tenFilm, f.rating
from film f
where f.rating = (select min(rating) from film);

-- 25. Liệt kê các studio có nhiều hơn 5 phim.
-- RA: γ_studioID; count(IDFilm)>5(film)
select s.studioID, s.tenStudio, count(f.IDFilm) as so_phim
from studio s
    join film f on s.studioID = f.studioID
group by s.studioID, s.tenStudio
having count(f.IDFilm) > 5;

-- 26. Liệt kê các diễn viên đã từng đóng phim thuộc thể loại 'Comedy'.
-- RA: π_IDCaNhan,ho,ten(σ_theLoai LIKE '%comedy%'(film ⨝ nhanVat ⨝ thongTinCaNhan))
select distinct ttcn.IDCaNhan, ttcn.ho || ' ' || ttcn.ten as ho_va_ten
from thongTinCaNhan ttcn
    join nhanVat nv on ttcn.IDCaNhan = nv.IDDienVien
    join film f on nv.IDFilm = f.IDFilm
where lower(f.theLoai) like '%comedy%';

-- 27. Liệt kê các phim có nhiều hơn 1 thể loại.
-- RA: π_IDFilm,tenFilm(σ_theLoai LIKE '%,%'(film))
select f.IDFilm, f.tenFilm
from film f
where f.theLoai like '%,%';

-- 28. Liệt kê các phim không có diễn viên nữ tham gia.
-- RA: π_IDFilm(¬∃(σ_gioiTinh='female'(thongTinCaNhan ⨝ nhanVat ⨝ film)))
select f.IDFilm, f.tenFilm
from film f
where not exists (
    select 1 from nhanVat nv
        join thongTinCaNhan ttcn on nv.IDDienVien = ttcn.IDCaNhan
    where nv.IDFilm = f.IDFilm and lower(ttcn.gioiTinh) in ('f', 'female')
);

-- 29. Liệt kê các phim có đạo diễn là nữ.
-- RA: π_IDFilm,tenFilm(σ_gioiTinh='female'(daoDien ⨝ thongTinCaNhan ⨝ film))
select distinct f.IDFilm, f.tenFilm
from film f
    join daoDien dd on f.IDFilm = dd.IDFilm
    join thongTinCaNhan ttcn on dd.IDDaoDien = ttcn.IDCaNhan
where lower(ttcn.gioiTinh) in ('f', 'female');

-- 30. Liệt kê các phim có ít nhất 2 diễn viên chính.
-- RA: γ_IDFilm; count(vaiChinh=1)≥2(nhanVat)
select nv.IDFilm
from nhanVat nv
where nv.vaiChinh = 1
group by nv.IDFilm
having count(*) >= 2;

-- 31. Liệt kê các phim có rating lớn hơn rating trung bình của tất cả các phim.
-- RA: π_IDFilm,tenFilm,rating(σ_rating>avg(rating)(film))
select f.IDFilm, f.tenFilm, f.rating
from film f
where f.rating > (select avg(rating) from film);

-- 32. Liệt kê các diễn viên đã từng đóng phim do studio 'Warner Bros' sản xuất.
-- RA: π_IDCaNhan,ho,ten(σ_tenStudio='Warner Bros'(film ⨝ studio ⨝ nhanVat ⨝ thongTinCaNhan))
select distinct ttcn.IDCaNhan, ttcn.ho || ' ' || ttcn.ten as ho_va_ten
from thongTinCaNhan ttcn
    join nhanVat nv on ttcn.IDCaNhan = nv.IDDienVien
    join film f on nv.IDFilm = f.IDFilm
    join studio s on f.studioID = s.studioID
where lower(s.tenStudio) = 'warner bros';

-- 33. Liệt kê các phim có ít hơn 3 diễn viên chính.
-- RA: γ_IDFilm; count(vaiChinh=1)<3(nhanVat)
select nv.IDFilm
from nhanVat nv
where nv.vaiChinh = 1
group by nv.IDFilm
having count(*) < 3;

-- 34. Liệt kê các phim có tổng thời lượng lớn hơn 150 phút.
-- RA: π_IDFilm,tenFilm,thoiLuong(σ_thoiLuong>150(film))
select f.IDFilm, f.tenFilm, f.thoiLuong
from film f
where f.thoiLuong > 150;

-- 35. Liệt kê các phim có rating nằm trong top 10 cao nhất.
-- RA: π_IDFilm,tenFilm,rating(σ_rating∈top10(rating)(film))
select f.IDFilm, f.tenFilm, f.rating
from (
    select *, row_number() over (order by rating desc) as rn from film
) f
where f.rn <= 10;

-- 36. Liệt kê các diễn viên đã từng đóng vai phản diện.
-- RA: π_IDCaNhan,ho,ten(σ_vaiPhanDien=1(nhanVat ⨝ thongTinCaNhan))
select distinct ttcn.IDCaNhan, ttcn.ho || ' ' || ttcn.ten as ho_va_ten
from thongTinCaNhan ttcn
    join nhanVat nv on ttcn.IDCaNhan = nv.IDDienVien
where nv.vaiPhanDien = 1;

-- 37. Liệt kê các phim có ít nhất 1 diễn viên từng đoạt giải Oscar.
-- RA: π_IDFilm(σ_giaiThuong='Oscar'(thongTinCaNhan ⨝ nhanVat ⨝ film))
select distinct f.IDFilm, f.tenFilm
from film f
    join nhanVat nv on f.IDFilm = nv.IDFilm
    join thongTinCaNhan ttcn on nv.IDDienVien = ttcn.IDCaNhan
where lower(ttcn.giaiThuong) like '%oscar%';

-- 38. Liệt kê các phim có doanh thu thấp nhất.
-- RA: π_IDFilm,tenFilm,doanhThu(σ_doanhThu=min(doanhThu)(film))
select f.IDFilm, f.tenFilm, f.doanhThu
from film f
where f.doanhThu = (select min(doanhThu) from film);

-- 39. Liệt kê các phim có rating lớn hơn 9.
-- RA: π_IDFilm,tenFilm,rating(σ_rating>9(film))
select f.IDFilm, f.tenFilm, f.rating
from film f
where f.rating > 9;

-- 40. Liệt kê các phim có đạo diễn từng đoạt giải Oscar.
-- RA: π_IDFilm,tenFilm(σ_giaiThuong='Oscar'(daoDien ⨝ thongTinCaNhan ⨝ film))
select distinct f.IDFilm, f.tenFilm
from film f
    join daoDien dd on f.IDFilm = dd.IDFilm
    join thongTinCaNhan ttcn on dd.IDDaoDien = ttcn.IDCaNhan
where lower(ttcn.giaiThuong) like '%oscar%';

-- 41. Liệt kê các phim có nhiều hơn 2 đạo diễn nữ.
-- RA: γ_IDFilm; count(gioiTinh='female')>2(daoDien ⨝ thongTinCaNhan)
select dd.IDFilm
from daoDien dd
    join thongTinCaNhan ttcn on dd.IDDaoDien = ttcn.IDCaNhan
where lower(ttcn.gioiTinh) in ('f', 'female')
group by dd.IDFilm
having count(*) > 2;

-- 42. Liệt kê các phim có rating nhỏ hơn 5.
-- RA: π_IDFilm,tenFilm,rating(σ_rating<5(film))
select f.IDFilm, f.tenFilm, f.rating
from film f
where f.rating < 5;

-- 43. Liệt kê các phim có doanh thu lớn hơn doanh thu trung bình.
-- RA: π_IDFilm,tenFilm,doanhThu(σ_doanhThu>avg(doanhThu)(film))
select f.IDFilm, f.tenFilm, f.doanhThu
from film f
where f.doanhThu > (select avg(doanhThu) from film);

-- 44. Liệt kê các phim có thời lượng nhỏ hơn 90 phút.
-- RA: π_IDFilm,tenFilm,thoiLuong(σ_thoiLuong<90(film))
select f.IDFilm, f.tenFilm, f.thoiLuong
from film f
where f.thoiLuong < 90;

-- 45. Liệt kê các phim có rating lớn hơn 7 và doanh thu lớn hơn 50 triệu USD.
-- RA: π_IDFilm,tenFilm,rating,doanhThu(σ_rating>7 ∧ doanhThu>50000000(film))
select f.IDFilm, f.tenFilm, f.rating, f.doanhThu
from film f
where f.rating > 7 and f.doanhThu > 50000000;

-- 46. Liệt kê các phim có đạo diễn là nam.
-- RA: π_IDFilm,tenFilm(σ_gioiTinh='male'(daoDien ⨝ thongTinCaNhan ⨝ film))
select distinct f.IDFilm, f.tenFilm
from film f
    join daoDien dd on f.IDFilm = dd.IDFilm
    join thongTinCaNhan ttcn on dd.IDDaoDien = ttcn.IDCaNhan
where lower(ttcn.gioiTinh) in ('m', 'male');

-- 47. Liệt kê các phim có ít hơn 2 diễn viên nữ.
-- RA: γ_IDFilm; count(gioiTinh='female')<2(nhanVat ⨝ thongTinCaNhan)
select nv.IDFilm
from nhanVat nv
    join thongTinCaNhan ttcn on nv.IDDienVien = ttcn.IDCaNhan
where lower(ttcn.gioiTinh) in ('f', 'female')
group by nv.IDFilm
having count(*) < 2;

-- 48. Liệt kê các phim có ít hơn 2 diễn viên nam.
-- RA: γ_IDFilm; count(gioiTinh='male')<2(nhanVat ⨝ thongTinCaNhan)
select nv.IDFilm
from nhanVat nv
    join thongTinCaNhan ttcn on nv.IDDienVien = ttcn.IDCaNhan
where lower(ttcn.gioiTinh) in ('m', 'male')
group by nv.IDFilm
having count(*) < 2;

-- 49. Liệt kê các phim có rating lớn hơn 8 và thời lượng lớn hơn 120 phút.
-- RA: π_IDFilm,tenFilm,rating,thoiLuong(σ_rating>8 ∧ thoiLuong>120(film))
select f.IDFilm, f.tenFilm, f.rating, f.thoiLuong
from film f
where f.rating > 8 and f.thoiLuong > 120;

-- 50. Liệt kê các phim có rating nhỏ hơn 6 và doanh thu nhỏ hơn 10 triệu USD.
-- RA: π_IDFilm,tenFilm,rating,doanhThu(σ_rating<6 ∧ doanhThu<10000000(film))
select f.IDFilm, f.tenFilm, f.rating, f.doanhThu
from film f
where f.rating < 6 and f.doanhThu < 10000000;

-- 51. Liệt kê các phim có rating lớn hơn 8 và thể loại là 'Drama'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating>8 ∧ theLoai LIKE '%drama%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating > 8 and lower(f.theLoai) like '%drama%';

-- 52. Liệt kê các phim có rating nhỏ hơn 5 và thể loại là 'Horror'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating<5 ∧ theLoai LIKE '%horror%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating < 5 and lower(f.theLoai) like '%horror%';

-- 53. Liệt kê các phim có rating lớn hơn 7 và thể loại là 'Sci-Fi'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating>7 ∧ theLoai LIKE '%sci-fi%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating > 7 and lower(f.theLoai) like '%sci-fi%';

-- 54. Liệt kê các phim có rating nhỏ hơn 6 và thể loại là 'Romance'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating<6 ∧ theLoai LIKE '%romance%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating < 6 and lower(f.theLoai) like '%romance%';

-- 55. Liệt kê các phim có rating lớn hơn 8 và thể loại là 'Animation'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating>8 ∧ theLoai LIKE '%animation%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating > 8 and lower(f.theLoai) like '%animation%';

-- 56. Liệt kê các phim có rating nhỏ hơn 5 và thể loại là 'Documentary'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating<5 ∧ theLoai LIKE '%documentary%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating < 5 and lower(f.theLoai) like '%documentary%';

-- 57. Liệt kê các phim có rating lớn hơn 7 và thể loại là 'Adventure'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating>7 ∧ theLoai LIKE '%adventure%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating > 7 and lower(f.theLoai) like '%adventure%';

-- 58. Liệt kê các phim có rating nhỏ hơn 6 và thể loại là 'Fantasy'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating<6 ∧ theLoai LIKE '%fantasy%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating < 6 and lower(f.theLoai) like '%fantasy%';

-- 59. Liệt kê các phim có rating lớn hơn 8 và thể loại là 'Mystery'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating>8 ∧ theLoai LIKE '%mystery%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating > 8 and lower(f.theLoai) like '%mystery%';

-- 60. Liệt kê các phim có rating nhỏ hơn 5 và thể loại là 'Crime'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating<5 ∧ theLoai LIKE '%crime%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating < 5 and lower(f.theLoai) like '%crime%';

-- 61. Liệt kê các phim có rating lớn hơn 7 và thể loại là 'Biography'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating>7 ∧ theLoai LIKE '%biography%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating > 7 and lower(f.theLoai) like '%biography%';

-- 62. Liệt kê các phim có rating nhỏ hơn 6 và thể loại là 'History'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating<6 ∧ theLoai LIKE '%history%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating < 6 and lower(f.theLoai) like '%history%';

-- 63. Liệt kê các phim có rating lớn hơn 8 và thể loại là 'Family'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating>8 ∧ theLoai LIKE '%family%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating > 8 and lower(f.theLoai) like '%family%';

-- 64. Liệt kê các phim có rating nhỏ hơn 5 và thể loại là 'Music'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating<5 ∧ theLoai LIKE '%music%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating < 5 and lower(f.theLoai) like '%music%';

-- 65. Liệt kê các phim có rating lớn hơn 7 và thể loại là 'War'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating>7 ∧ theLoai LIKE '%war%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating > 7 and lower(f.theLoai) like '%war%';

-- 66. Liệt kê các phim có rating nhỏ hơn 6 và thể loại là 'Sport'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating<6 ∧ theLoai LIKE '%sport%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating < 6 and lower(f.theLoai) like '%sport%';

-- 67. Liệt kê các phim có rating lớn hơn 8 và thể loại là 'Western'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating>8 ∧ theLoai LIKE '%western%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating > 8 and lower(f.theLoai) like '%western%';

-- 68. Liệt kê các phim có rating nhỏ hơn 5 và thể loại là 'Thriller'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating<5 ∧ theLoai LIKE '%thriller%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating < 5 and lower(f.theLoai) like '%thriller%';

-- 69. Liệt kê các phim có rating lớn hơn 7 và thể loại là 'Musical'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating>7 ∧ theLoai LIKE '%musical%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating > 7 and lower(f.theLoai) like '%musical%';

-- 70. Liệt kê các phim có rating nhỏ hơn 6 và thể loại là 'Short'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating<6 ∧ theLoai LIKE '%short%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating < 6 and lower(f.theLoai) like '%short%';

-- 71. Liệt kê các phim có rating lớn hơn 8 và thể loại là 'Film-Noir'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating>8 ∧ theLoai LIKE '%film-noir%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating > 8 and lower(f.theLoai) like '%film-noir%';

-- 72. Liệt kê các phim có rating nhỏ hơn 5 và thể loại là 'News'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating<5 ∧ theLoai LIKE '%news%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating < 5 and lower(f.theLoai) like '%news%';

-- 73. Liệt kê các phim có rating lớn hơn 7 và thể loại là 'Reality-TV'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating>7 ∧ theLoai LIKE '%reality-tv%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating > 7 and lower(f.theLoai) like '%reality-tv%';

-- 74. Liệt kê các phim có rating nhỏ hơn 6 và thể loại là 'Talk-Show'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating<6 ∧ theLoai LIKE '%talk-show%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating < 6 and lower(f.theLoai) like '%talk-show%';

-- 75. Liệt kê các phim có rating lớn hơn 8 và thể loại là 'Game-Show'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating>8 ∧ theLoai LIKE '%game-show%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating > 8 and lower(f.theLoai) like '%game-show%';

-- 76. Liệt kê các phim có rating nhỏ hơn 5 và thể loại là 'Reality-TV'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating<5 ∧ theLoai LIKE '%reality-tv%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating < 5 and lower(f.theLoai) like '%reality-tv%';

-- 77. Liệt kê các phim có rating lớn hơn 7 và thể loại là 'News'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating>7 ∧ theLoai LIKE '%news%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating > 7 and lower(f.theLoai) like '%news%';

-- 78. Liệt kê các phim có rating nhỏ hơn 6 và thể loại là 'Game-Show'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating<6 ∧ theLoai LIKE '%game-show%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating < 6 and lower(f.theLoai) like '%game-show%';

-- 79. Liệt kê các phim có rating lớn hơn 8 và thể loại là 'Talk-Show'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating>8 ∧ theLoai LIKE '%talk-show%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating > 8 and lower(f.theLoai) like '%talk-show%';

-- 80. Liệt kê các phim có rating nhỏ hơn 5 và thể loại là 'Short'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating<5 ∧ theLoai LIKE '%short%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating < 5 and lower(f.theLoai) like '%short%';

-- 81. Liệt kê các phim có rating lớn hơn 7 và thể loại là 'Film-Noir'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating>7 ∧ theLoai LIKE '%film-noir%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating > 7 and lower(f.theLoai) like '%film-noir%';

-- 82. Liệt kê các phim có rating nhỏ hơn 6 và thể loại là 'Western'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating<6 ∧ theLoai LIKE '%western%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating < 6 and lower(f.theLoai) like '%western%';

-- 83. Liệt kê các phim có rating lớn hơn 8 và thể loại là 'Sport'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating>8 ∧ theLoai LIKE '%sport%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating > 8 and lower(f.theLoai) like '%sport%';

-- 84. Liệt kê các phim có rating nhỏ hơn 5 và thể loại là 'War'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating<5 ∧ theLoai LIKE '%war%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating < 5 and lower(f.theLoai) like '%war%';

-- 85. Liệt kê các phim có rating lớn hơn 7 và thể loại là 'Music'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating>7 ∧ theLoai LIKE '%music%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating > 7 and lower(f.theLoai) like '%music%';

-- 86. Liệt kê các phim có rating nhỏ hơn 6 và thể loại là 'Family'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating<6 ∧ theLoai LIKE '%family%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating < 6 and lower(f.theLoai) like '%family%';

-- 87. Liệt kê các phim có rating lớn hơn 8 và thể loại là 'History'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating>8 ∧ theLoai LIKE '%history%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating > 8 and lower(f.theLoai) like '%history%';

-- 88. Liệt kê các phim có rating nhỏ hơn 5 và thể loại là 'Biography'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating<5 ∧ theLoai LIKE '%biography%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating < 5 and lower(f.theLoai) like '%biography%';

-- 89. Liệt kê các phim có rating lớn hơn 7 và thể loại là 'Crime'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating>7 ∧ theLoai LIKE '%crime%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating > 7 and lower(f.theLoai) like '%crime%';

-- 90. Liệt kê các phim có rating nhỏ hơn 6 và thể loại là 'Mystery'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating<6 ∧ theLoai LIKE '%mystery%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating < 6 and lower(f.theLoai) like '%mystery%';

-- 91. Liệt kê các phim có rating lớn hơn 8 và thể loại là 'Fantasy'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating>8 ∧ theLoai LIKE '%fantasy%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating > 8 and lower(f.theLoai) like '%fantasy%';

-- 92. Liệt kê các phim có rating nhỏ hơn 5 và thể loại là 'Adventure'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating<5 ∧ theLoai LIKE '%adventure%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating < 5 and lower(f.theLoai) like '%adventure%';

-- 93. Liệt kê các phim có rating lớn hơn 7 và thể loại là 'Documentary'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating>7 ∧ theLoai LIKE '%documentary%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating > 7 and lower(f.theLoai) like '%documentary%';

-- 94. Liệt kê các phim có rating nhỏ hơn 6 và thể loại là 'Animation'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating<6 ∧ theLoai LIKE '%animation%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating < 6 and lower(f.theLoai) like '%animation%';

-- 95. Liệt kê các phim có rating lớn hơn 8 và thể loại là 'Romance'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating>8 ∧ theLoai LIKE '%romance%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating > 8 and lower(f.theLoai) like '%romance%';

-- 96. Liệt kê các phim có rating nhỏ hơn 5 và thể loại là 'Sci-Fi'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating<5 ∧ theLoai LIKE '%sci-fi%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating < 5 and lower(f.theLoai) like '%sci-fi%';

-- 97. Liệt kê các phim có rating lớn hơn 7 và thể loại là 'Horror'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating>7 ∧ theLoai LIKE '%horror%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating > 7 and lower(f.theLoai) like '%horror%';

-- 98. Liệt kê các phim có rating nhỏ hơn 6 và thể loại là 'Drama'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating<6 ∧ theLoai LIKE '%drama%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating < 6 and lower(f.theLoai) like '%drama%';

-- 99. Liệt kê các phim có rating lớn hơn 8 và thể loại là 'Comedy'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating>8 ∧ theLoai LIKE '%comedy%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating > 8 and lower(f.theLoai) like '%comedy%';

-- 100. Liệt kê các phim có rating nhỏ hơn 5 và thể loại là 'Action'.
-- RA: π_IDFilm,tenFilm,rating,theLoai(σ_rating<5 ∧ theLoai LIKE '%action%'(film))
select f.IDFilm, f.tenFilm, f.rating, f.theLoai
from film f
where f.rating < 5 and lower(f.theLoai) like '%action%';