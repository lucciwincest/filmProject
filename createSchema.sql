
create table thongTinCaNhan
(
    IDCaNhan        smallint        not null,
    ten             varchar2(30)    default 'unknown',
    ho              varchar2(30)    default 'unknown',
    trangThai       varchar2(30)    default 'active',
    gioiTinh        varchar2(10)    default 'unknown' check(lower(gioiTinh) in ('male', 'female', 'unknown', 'm', 'f')),
    ngaySinh        date,
    chieuCao        number(3,2)     default 1.70 check(chieuCao > 0),
    tieuSu          clob,
    diaChi          varchar2(100)   default 'unknown',
    quocTich        varchar2(100)   default 'unknown',
    tel             varchar2(10)    unique,
    email           varchar2(30)    default 'unknown',

    primary key (IDCaNhan)
);


create table studio
(
    studioID        smallint        not null,
    tenStudio       varchar2(100)   default 'unknown',
    diaChi          varchar2(100)   default 'unknown',
    quocGia         varchar2(100)   default 'unknown',
    namThanhLap     number(4),

    primary key (studioID)
);


create table phanLoaiDoTuoi
(
    ageRating       varchar2(10)    not null,
    minimumAge      smallint        check(minimumAge >= 0),
    dinhNghia       clob,

    primary key (ageRating)
);


create table film
(
    IDFilm              smallint        not null,
    tenFilm             varchar2(100)   default 'unknown',
    loai                varchar2(15)    default 'unknown',
    soTap               smallint        default 1,
    thoiLuong           integer         check(thoiLuong > 0),
    theLoai             varchar2(100)   default 'unknown',
    tomTat              clob,
    ngonNgu             varchar2(100)   default 'unknown',
    quocGia             varchar2(100)   default 'unknown',
    rating              number(2,1)     check(rating between 0 and 10),
    ngayPhatHanh        date,
    nganSach            integer         default 1000000 check (nganSach >= 0),
    doanhThu            integer         default 1000000 check (doanhThu >= 0),
    check
    (
        (lower(loai) not like '%series' and soTap = 1)
        or
        (lower(loai) like '%series' and soTap >= 1)
    ),                          


    ageRating	    varchar2(10)    default 'G',
    studioID        smallint,

    primary key (IDFilm),
    foreign key (ageRating)     references phanLoaiDoTuoi (ageRating),
    foreign key (studioID)      references studio (studioID)
);


create table daoDien
(
    IDFilm          smallint        not null,
    IDDaoDien       smallint        not null,

    primary key (IDFilm, IDDaoDien),
    foreign key (IDFilm)        references film (IDFilm),
    foreign key (IDDaoDien)     references thongTinCaNhan (IDCaNhan)
);


create table nhanVat
(
    IDNhanVat       smallint        not null,
    tenNhanVat      varchar2(30)    default 'unknown',
    gioiTinh        varchar2(10)    default 'unknown' check(lower(gioiTinh) in ('male', 'female', 'unknown', 'm', 'f')),
    chieuCao        number(3, 2)    default 1.70 check(chieuCao > 0),

    IDFilm	        smallint        not null,
    IDDienVien      smallint,

    primary key (IDNhanVat, IDFilm),
    foreign key (IDFilm)            references film (IDFilm),
    foreign key (IDDIenVien)        references thongTinCaNhan (IDCaNhan)
);
