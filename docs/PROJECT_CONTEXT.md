# PROJECT_CONTEXT — Hệ thống kết nối nhân sự và quản lý cộng tác dự án đa ngành

> Tài liệu tổng hợp ngữ cảnh dự án, lập ngày 2026-11-05 từ các tài liệu và source code có trong repository tại thời điểm phân tích (nhánh `main`, commit `2e70f88`).
> Mục đích: giúp thành viên mới (hoặc công cụ AI) nắm nhanh nghiệp vụ, thiết kế, hiện trạng triển khai và các rủi ro mà không phải đọc lại toàn bộ tài liệu gốc.
> Cập nhật 2026-11-05: mục 6.1, 7.1, 8 và các mục liên quan đã đồng bộ với phân công chính thức và các quyết định/đề xuất mới nhất của nhóm (xem `docs/TEAM_WORKFLOW.md`). Quyết định và đề xuất được tách bằng nhãn **[Đã quyết định]** / **[Đề xuất]**. Lượt cập nhật sau bổ sung: ma trận trạng thái dự án đề xuất (2.3), đóng tuyển dụng, contract tích hợp, exception/response, API tiến độ, chia thư mục frontend và branch (mục 6.1, 6.2, 7.1, 8).
> Tài liệu này **chỉ tổng hợp và đối chiếu**; không thay thế tài liệu gốc. Khi có mâu thuẫn, ưu tiên theo thứ tự: PDF thiết kế (nghiệp vụ) → `database/schema/001_create_tables.sql` (cấu trúc dữ liệu thực tế) → các README.

## 0. Cách đọc tài liệu này

### 0.1. Bốn nhãn trạng thái

| Nhãn | Ý nghĩa |
|------|---------|
| **[Thiết kế]** | Đã được mô tả trong tài liệu (PDF, ERD, README, TEAM_WORKFLOW, API_CONTRACT). |
| **[Đã triển khai]** | Đã có trong source code / script thực tế của repository. |
| **[Chưa triển khai]** | Đã được thiết kế hoặc yêu cầu, nhưng chưa có code tương ứng. |
| **[Chưa đủ thông tin]** | Không thể xác định từ những gì có trong repository; cần hỏi nhóm. |

Một mục có thể mang nhiều nhãn (ví dụ: "[Thiết kế] + [Chưa triển khai]").

### 0.2. Cách ghi nguồn căn cứ

- **PDF** = `docs/reports/bài phân tích và thiết kế CSDL.pdf` (báo cáo Nhóm 9, tháng 10/2026). Trích dẫn theo **số mục và số trang in trên trang** (ví dụ: "PDF §1.6, tr. 5"). Lưu ý: số trang in lệch 3 so với số trang của trình đọc PDF (trang bìa và mục lục không đánh số theo thân bài).
- **ERD** = `docs/database/ERD/ERD.png` (sơ đồ ký hiệu Chen; cũng là Hình 1 trong PDF, tr. 9 của trình đọc).
- **Schema** = `database/schema/001_create_tables.sql`; **Seed** = `database/seeds/002_sample_data.sql`.
- Đường dẫn file khác ghi nguyên văn, tính từ thư mục gốc repository.

### 0.3. Quy ước thuật ngữ

Thuật ngữ chuyên ngành được giữ nguyên tiếng Anh và giải thích ở lần xuất hiện đầu tiên: **Entity** (thực thể), **Primary Key / PK** (khóa chính), **Foreign Key / FK** (khóa ngoại), **Cardinality** (bản số của quan hệ: 1–1, 1–N, N–N), **Migration** (script thay đổi cấu trúc CSDL theo thứ tự phiên bản), **Trigger** (đoạn mã CSDL tự chạy khi dữ liệu thay đổi), **Seed** (dữ liệu mẫu), **API** (giao diện lập trình để Frontend gọi Backend), **Backend / Frontend** (phần máy chủ / phần giao diện người dùng), **JWT** (JSON Web Token – chuỗi xác thực gửi kèm mỗi request), **CORS** (cơ chế cho phép trình duyệt gọi API khác nguồn), **Partial unique index** (chỉ mục duy nhất có điều kiện, chỉ áp dụng trên các dòng thỏa điều kiện).

---

## 1. Tổng quan dự án

### 1.1. Mô tả

Nền tảng **kết nối nhân sự và quản lý cộng tác dự án đa ngành**. Người tạo dự án đăng các **vị trí (position)** còn thiếu cùng yêu cầu kỹ năng; người dùng tìm kiếm, xem gợi ý và ứng tuyển; chủ dự án duyệt đơn, phân công công việc, theo dõi tiến độ, cảnh báo dự án đình trệ và bàn giao quyền owner khi cần. Hỗ trợ nhiều lĩnh vực (CNTT, thiết kế, marketing, nghiên cứu…).
Nguồn: PDF §1.1–1.2, tr. 1; `README.md` (mục Features).

### 1.2. Bối cảnh học thuật

Đây là **bài tập lớn cuối kỳ môn Cơ sở dữ liệu**, Khoa Toán – Cơ – Tin học, Trường ĐH Khoa học Tự nhiên – ĐHQGHN, **Nhóm 9**, 5 thành viên (PDF, trang bìa). Nội dung PDF gồm: Requirements → ERD Chen → lược đồ quan hệ → chuẩn hóa (1NF–BCNF) → lược đồ 16 bảng.

### 1.3. Phạm vi và ranh giới

| Nội dung | Căn cứ |
|----------|--------|
| Chỉ làm **matchmaking** (kết nối) và **quản lý dự án**; **không** tích hợp tự động GitHub/GitLab. `repository_url` chỉ lưu để tham khảo (có thể trống). | `README.md` (Scope note); PDF §1.2, tr. 1; PDF §6.2–6.3, tr. 22 |
| Kỹ năng do người dùng tự khai, **chưa xác minh**. | PDF §1.2, §6.3 |
| Danh mục kỹ năng và lĩnh vực được **chuẩn bị trước**; giao diện quản trị danh mục **không thuộc phạm vi phiên bản đầu**. | PDF §1.5 FR02, tr. 3 |
| Không hỗ trợ dự án riêng tư và phân quyền chi tiết ngoài owner/member. | PDF §6.3, tr. 22 |

### 1.3b. Công nghệ

| Tầng | Công nghệ | Nguồn kiểm chứng |
|------|-----------|------------------|
| CSDL | PostgreSQL 16 (image `postgres:16-alpine`), script SQL thuần | `docker-compose.yml`, `README.md` |
| Backend | Java 21 (`java.version`), Spring Boot **3.5.0**, Maven, Spring Web, Data JPA, Security, Validation, driver PostgreSQL, JJWT 0.12.6, JUnit 5/Mockito (qua `spring-boot-starter-test`) | `backend/pom.xml` |
| Frontend | React 18.3, Vite 6, TypeScript 5.6, React Router 6, Axios, Tailwind CSS 3, Lucide React | `frontend/package.json` |
| Công cụ | Git + GitHub, Docker Compose, Postman (chỉ có thư mục trống), GitHub Actions | `.github/workflows/ci.yml`, `postman/README.md` |

---

## 2. Yêu cầu nghiệp vụ

Toàn bộ nội dung mục này là **[Thiết kế]** (PDF §1, tr. 1–5). Trạng thái triển khai xem mục 9–10.

### 2.1. Yêu cầu chức năng (FR01–FR12)

| Mã | Chức năng | Điểm chính (PDF §1.5) |
|----|-----------|------------------------|
| FR01 | Quản lý tài khoản | Đăng ký bằng email + mật khẩu, đăng nhập, đăng xuất; cập nhật họ tên/giới thiệu/đường dẫn hồ sơ; email duy nhất; chỉ sửa hồ sơ của mình; mật khẩu băm trước khi lưu. (tr. 2–3) |
| FR02 | Quản lý kỹ năng | Thêm/đổi mức/xóa kỹ năng cá nhân; level 1–5; mỗi người một mức cho mỗi kỹ năng; mỗi kỹ năng thuộc ≥ 1 lĩnh vực. (tr. 3) |
| FR03 | Quản lý dự án | Tạo dự án (tên, mô tả, ≥ 1 lĩnh vực), khai báo `repository_url`; khi tạo, người tạo tự là owner; owner cập nhật thông tin/lĩnh vực/trạng thái; người tạo ban đầu không đổi sau bàn giao. (tr. 3) |
| FR04 | Quản lý vị trí tuyển | Owner tạo/sửa/mở/đóng vị trí; mỗi vị trí thuộc đúng 1 dự án; có thể yêu cầu nhiều kỹ năng với mức tối thiểu; kỹ năng yêu cầu phải thuộc cùng lĩnh vực với dự án; không giảm `slots` dưới số người đang đảm nhiệm. (tr. 3) |
| FR05 | Tìm kiếm và gợi ý | Tìm theo từ khóa/lĩnh vực/kỹ năng; lọc vị trí mở và còn chỗ; gợi ý theo kỹ năng; hiển thị kỹ năng đạt/chưa đạt; không gợi ý vị trí đang đảm nhiệm. Điểm phù hợp = tỷ lệ kỹ năng đạt mức tối thiểu / tổng kỹ năng yêu cầu; vị trí không yêu cầu kỹ năng hiển thị "Chưa có tiêu chí đánh giá". (tr. 3) |
| FR06 | Quản lý đơn ứng tuyển | Gửi đơn vào 1 vị trí kèm lời giới thiệu; chỉ gửi khi vị trí mở, còn chỗ, dự án cho phép tuyển; không có 2 đơn `pending` cùng cặp (vị trí, người nộp); được rút đơn đang chờ; thành viên được ứng tuyển thêm vị trí khác; muốn nộp lại phải tạo đơn mới. (tr. 3) |
| FR07 | Xét duyệt đơn | Owner chấp nhận/từ chối đơn `pending`; lưu người xử lý và thời điểm; khi chấp nhận kiểm tra lại quyền, trạng thái, số chỗ; thêm hoặc khôi phục thành viên và ghi nhận vị trí đảm nhiệm; tất cả trong **cùng một giao dịch**. (tr. 4) |
| FR08 | Quản lý thành viên và vị trí đảm nhiệm | Hiển thị thành viên đang hoạt động và đã rời; một thành viên đảm nhiệm nhiều vị trí; kết thúc 1 vị trí không buộc rời dự án; khi rời, kết thúc các đảm nhiệm/phân công đang có hiệu lực; owner phải bàn giao trước khi rời. (tr. 4) |
| FR09 | Quản lý công việc | Owner tạo/sửa/phân công; mỗi task thuộc 1 dự án; task có thể chưa phân công hoặc giao nhiều thành viên; chỉ giao cho thành viên đang hoạt động cùng dự án; owner và người được giao cập nhật trạng thái; `done` ghi `completed_at`, mở lại thì xóa. (tr. 4) |
| FR10 | Theo dõi tiến độ và nhân sự | Tiến độ = task `done` / tổng task × 100%; chưa có task → "Chưa có dữ liệu"; hiển thị số người đang đảm nhiệm và số chỗ trống từng vị trí; người kiêm nhiều vị trí chỉ tính một thành viên; phân biệt "chưa đủ người" và "đang mở tuyển". (tr. 4) |
| FR11 | Cảnh báo nguy cơ đình trệ | Theo dõi `last_activity_at`; chỉ cảnh báo dự án đang hoạt động không có hoạt động có ý nghĩa trong ngưỡng cấu hình (**chưa cố định, tham khảo 14 ngày**); không tự kết luận dự án bị bỏ hoặc đổi trạng thái. Quy ước: tạo task/đổi trạng thái task = hoạt động; xem trang, đăng nhập, sửa chính tả = không. Khởi tạo `last_activity_at = created_at`. (tr. 4) |
| FR12 | Bàn giao và lưu lịch sử | Owner gửi yêu cầu cho một người nhận cụ thể; người nhận chấp nhận/từ chối, người giao hủy khi đang chờ; tối đa 1 yêu cầu `pending` mỗi dự án; khi chấp nhận kiểm tra lại owner hiện tại; người nhận phải là thành viên hoạt động (hoặc được thêm/khôi phục cùng giao dịch); owner cũ thành member; lưu mỗi lần đổi trạng thái dự án vào lịch sử. (tr. 4–5) |

### 2.2. Quy tắc nghiệp vụ (BR1–BR14) — PDF §1.6, tr. 5

| Mã | Nội dung (tóm tắt) |
|----|--------------------|
| BR1 | Cặp (người dùng, dự án) định danh duy nhất một thành viên. |
| BR2 | Mỗi dự án có **đúng một** owner đang hoạt động tại thời điểm giao dịch hoàn tất. |
| BR3 | Người tạo ban đầu và owner hiện tại có thể khác nhau. |
| BR4 | Mỗi kỹ năng, dự án thuộc ít nhất một lĩnh vực. |
| BR5 | `slots` là tổng số người cần cho vị trí, số nguyên dương. |
| BR6 | Số người đang đảm nhiệm hợp lệ không vượt `slots`. |
| BR7 | Thành viên, vị trí đảm nhiệm và công việc được giao phải cùng dự án. |
| BR8 | `level`, `min_level` là số nguyên 1–5. |
| BR9 | Phiên bản đầu: chỉ owner được duyệt đơn, quản lý phân công và khởi tạo bàn giao. |
| BR10 | Người giao và người nhận bàn giao phải khác nhau. |
| BR11 | Đơn đã kết thúc không được chấp nhận lần nữa. |
| BR12 | Không xóa cứng dữ liệu đang được lịch sử tham chiếu. |
| BR13 | Duyệt đồng thời không được làm vượt chỗ; bàn giao không được tạo hai owner. |
| BR14 | Mốc kết thúc không được trước mốc bắt đầu tương ứng. |

### 2.3. Giá trị trạng thái và chính sách vận hành — PDF §1.6, tr. 5

| Đối tượng | Giá trị hợp lệ |
|-----------|----------------|
| Dự án | `planning`, `active`, `paused`, `completed`, `cancelled` |
| Vị trí | `open`, `closed` |
| Đơn ứng tuyển | `pending`, `accepted`, `rejected`, `withdrawn` |
| Công việc | `todo`, `in_progress`, `done` |
| Bàn giao | `pending`, `accepted`, `rejected`, `cancelled` |

Chính sách: chỉ dự án `planning` hoặc `active` được nhận và duyệt đơn; dự án `completed`/`cancelled` thì đóng các vị trí đang tuyển; đơn `pending` còn lại không được chấp nhận khi dự án đã kết thúc; mở lại vị trí thì `closed_at` về trống; `decided_at` chỉ ghi thời điểm chấp nhận/từ chối (không có thời điểm riêng cho rút đơn/hủy bàn giao).

**Ma trận chuyển trạng thái dự án — [Đề xuất], chưa áp dụng.** PDF chỉ liệt kê giá trị trạng thái, **không quy định chuyển nào hợp lệ**. Nhóm đề xuất (2026-11-05):

- `draft` → `open`, `cancelled`
- `open` → `paused`, `completed`, `cancelled`
- `paused` → `open`, `completed`, `cancelled`
- `completed`, `cancelled` là trạng thái kết thúc.

Đối chiếu: enum thực tế trong PDF §1.6, `ck_project_status` của `database/schema/001_create_tables.sql` và seed là `planning`, `active`, `paused`, `completed`, `cancelled`. Source code Java chưa có enum. `draft` và `open` **không tồn tại** ở bất kỳ nguồn nào, và `open` còn là trạng thái của `position`. Vì vậy ma trận **không tương thích về tên** và không được áp dụng; không sửa code, schema hay migration. *Suy luận của người phân tích, chưa xác nhận:* nếu giữ enum hiện tại và coi `draft` ≈ `planning`, `open` ≈ `active` thì ma trận là `planning` → `active`, `cancelled`; `active` → `paused`, `completed`, `cancelled`; `paused` → `active`, `completed`, `cancelled`. Schema chỉ có `CHECK (old_status <> new_status)`, không ràng buộc chuyển hợp lệ. Chi tiết: `docs/TEAM_WORKFLOW.md` mục 2.2.1; câu hỏi mở: 8.6 mục 2–4.

### 2.4. Yêu cầu phi chức năng — PDF §1.7, tr. 5

Kiểm tra quyền ở phía máy chủ; bảo vệ mật khẩu/phiên đăng nhập/thông tin cá nhân; dùng giao dịch cho duyệt đơn, rời dự án, đổi trạng thái, bàn giao; phân trang và chỉ mục phục vụ tìm kiếm; sao lưu và kiểm tra phục hồi; thống nhất lưu thời gian và múi giờ; thông báo rõ lý do khi thao tác thất bại.

### 2.5. Giới hạn đã được nhóm thừa nhận — PDF §6.3, tr. 22

Kỹ năng/mức độ tự khai; `last_activity_at` chưa đồng bộ hoạt động nền tảng ngoài; tiến độ chỉ dựa số lượng task; chưa lưu lịch sử chi tiết sửa task/yêu cầu kỹ năng; chưa lưu đầy đủ các lần đóng/mở vị trí; chưa có thời điểm rút đơn/hủy bàn giao riêng; chưa hỗ trợ dự án riêng tư.

---

## 3. Vai trò người dùng và các trường hợp sử dụng

### 3.1. Tác nhân — PDF §1.3, tr. 1 **[Thiết kế]**

| Tác nhân | Quyền / hành động chính |
|----------|--------------------------|
| Khách chưa đăng nhập | Xem và tìm kiếm dự án, vị trí công khai; đăng ký, đăng nhập. |
| Người dùng | Quản lý hồ sơ và kỹ năng; tạo dự án; gửi/xem/rút đơn ứng tuyển. |
| Thành viên dự án | Xem thông tin nội bộ của dự án mình tham gia; nhận vị trí, công việc và cập nhật trạng thái công việc được giao; ứng tuyển thêm vị trí hoặc rời dự án. |
| Chủ dự án (owner) | Quản lý dự án, vị trí, yêu cầu kỹ năng; duyệt đơn, quản lý thành viên, phân công; đổi trạng thái dự án và gửi yêu cầu bàn giao. |

**Điểm cần lưu ý (PDF tr. 1, hộp ghi chú):** owner/member là **quyền trong từng dự án** (cột `project_member.role`), không phải vai trò toàn hệ thống. Backend, Designer, Marketing… là **vị trí chuyên môn** (`position`), quản lý riêng. Một người có thể là owner của dự án này và member của dự án khác.

**[Chưa đủ thông tin]:** không có tài liệu nào nhắc tới vai trò quản trị hệ thống (admin) toàn cục. PDF chỉ nói giao diện quản trị danh mục kỹ năng/lĩnh vực nằm ngoài phạm vi (FR02).

### 3.2. Các trường hợp sử dụng (suy ra từ FR01–FR12)

> PDF không có sơ đồ use case riêng, thư mục `docs/requirements/` đang trống. Bảng dưới là **tổng hợp của người phân tích** từ FR, không phải tài liệu gốc.

| UC | Tác nhân | Luồng ngắn | Căn cứ |
|----|----------|-----------|--------|
| UC01 Đăng ký / đăng nhập | Khách | Nhập email + mật khẩu → tài khoản mới / nhận phiên đăng nhập. | FR01 |
| UC02 Quản lý hồ sơ & kỹ năng | Người dùng | Sửa hồ sơ; thêm/đổi/xóa kỹ năng với level 1–5. | FR01, FR02 |
| UC03 Tìm và xem gợi ý dự án/vị trí | Khách, Người dùng | Tìm theo từ khóa/lĩnh vực/kỹ năng; xem kỹ năng đạt/chưa đạt. | FR05 |
| UC04 Tạo dự án | Người dùng | Nhập thông tin + ≥ 1 lĩnh vực → dự án mới; người tạo thành owner. | FR03 |
| UC05 Quản lý vị trí tuyển | Owner | Tạo/sửa/đóng/mở vị trí, đặt yêu cầu kỹ năng. | FR04 |
| UC06 Ứng tuyển / rút đơn | Người dùng, Thành viên | Gửi đơn vào vị trí mở còn chỗ; rút đơn đang chờ. | FR06 |
| UC07 Duyệt đơn | Owner | Chấp nhận/từ chối → (nếu chấp nhận) thêm/khôi phục thành viên + ghi đảm nhiệm. | FR07 |
| UC08 Quản lý thành viên | Owner, Thành viên | Xem danh sách; kết thúc đảm nhiệm; rời dự án. | FR08 |
| UC09 Quản lý công việc | Owner, Thành viên | Owner tạo/giao; người được giao cập nhật trạng thái. | FR09 |
| UC10 Theo dõi tiến độ & cảnh báo | Owner | Xem % tiến độ, chỗ trống, cảnh báo đình trệ. | FR10, FR11 |
| UC11 Đổi trạng thái dự án | Owner | Đổi trạng thái → ghi lịch sử. | FR03, FR12 |
| UC12 Bàn giao owner | Owner, Người nhận | Gửi yêu cầu → người nhận chấp nhận/từ chối; người giao hủy. | FR12 |

---

## 4. Kiến trúc hệ thống

### 4.1. Sơ đồ tổng thể — **[Đã triển khai ở mức khung]**

```text
Trình duyệt ── React/Vite (:5173) ──HTTP/JSON (Axios, JWT Bearer – dự kiến)──▶ Spring Boot (:8080) ──JDBC──▶ PostgreSQL 16 (:5432, Docker)
```

Nguồn: `README.md`, `frontend/vite.config.ts` (port 5173), `application.yml` (port 8080), `docker-compose.yml`, `frontend/.env.example`.

### 4.2. Đặc điểm kiến trúc

| Đặc điểm | Chi tiết | Nguồn |
|----------|----------|-------|
| Monorepo | `backend/`, `frontend/`, `database/`, `docs/`, `deployment/`, `postman/` trong 1 repository | `README.md` |
| **SQL là nguồn sự thật của schema** | `spring.jpa.hibernate.ddl-auto: none`; Entity JPA phải viết theo SQL, không ngược lại | `application.yml`, `backend/README.md`, `CLAUDE.md` |
| Chỉ Postgres chạy trong Docker | Backend/Frontend chạy máy cục bộ khi phát triển; **không có Dockerfile** | `docker-compose.yml` (comment đầu file), `deployment/README.md` |
| Xác thực JWT | Biến `JWT_SECRET` (không có giá trị mặc định có chủ đích), `JWT_EXPIRATION_MS` mặc định 86400000 ms (24 giờ) | `application.yml`, `.env.example` |
| CORS | Một origin duy nhất từ biến `CORS_ALLOWED_ORIGIN` (mặc định `http://localhost:5173`) | `application.yml` |
| Profile | Mặc định `dev` (`show-sql: true`, log DEBUG) | `application.yml`, `application-dev.yml` |
| `open-in-view: false` | Không giữ session Hibernate qua tầng View | `application.yml` |
| Không có Dockerfile, không có môi trường staging/production | `deployment/` trống; mục tiêu triển khai ghi `TODO (Member 5)` | `deployment/README.md` |

### 4.3. CI — **[Đã triển khai]**

`.github/workflows/ci.yml` chạy trên PR và push vào `develop`/`main`: job backend (`mvn -B verify`, Temurin 21) và job frontend (`npm ci && npm run build`, Node 20). Không có bước lint, test frontend, hay triển khai.
**Chưa kiểm chứng:** tôi chưa chạy các lệnh này trong phiên phân tích (theo giới hạn không cài package/không sửa mã).

### 4.4. Chiến lược nhánh — `CONTRIBUTING.md`, `docs/TEAM_WORKFLOW.md` §3

`main` (demo ổn định) ← `develop` ← `feature/*`, `fix/*`; PR cần ≥ 1 review; commit theo `<type>(<scope>): ...`. Thay đổi schema phải qua Member 1; thay đổi `API_CONTRACT.md` phải qua một Backend và một Frontend review.

---

## 5. Thiết kế cơ sở dữ liệu

### 5.1. ERD Chen — phân tích từ `ERD.png` và PDF §2 (tr. 6–8) **[Thiết kế]**

**Ký hiệu** (PDF Bảng 3, tr. 6): hình chữ nhật = thực thể; chữ nhật đôi = thực thể yếu (weak entity, định danh nhờ thực thể khác) – `PROJECT_MEMBER`; hình thoi = quan hệ; thoi đôi = quan hệ định danh; elip = thuộc tính (gạch chân = khóa); **elip nét đứt = thuộc tính suy diễn (derived, không lưu)**; đường đôi = tham gia toàn phần; mũi tên hướng về phía "một".

**10 thực thể:** `USERS`, `DOMAIN`, `SKILL`, `PROJECT`, `POSITION`, `PROJECT_MEMBER` (thực thể yếu), `APPLICATION`, `TASK`, `PROJECT_STATUS_HISTORY`, `PROJECT_HANDOVER` (PDF Bảng 4, tr. 6).

**6 quan hệ N–N có thuộc tính** (PDF Bảng 6, tr. 7): `USER_SKILL` (`level`), `SKILL_DOMAIN`, `PROJECT_DOMAIN`, `POSITION_SKILL_REQUIREMENT` (`min_level`), `POSITION_ASSIGNMENT` (`started_at`, `ended_at`), `TASK_ASSIGNMENT` (`assigned_at`, `unassigned_at`).

**13 quan hệ 1–N** (PDF Bảng 7, tr. 8) → khóa ngoại:

| Quan hệ | Khóa ngoại |
|---------|-----------|
| `CREATES` | `PROJECT.creator_id` |
| `POSITION_OF` | `POSITION.project_id` |
| `TASK_OF` | `TASK.project_id` |
| `MEMBERSHIP_OF_USER` (định danh) | `PROJECT_MEMBER.user_id` |
| `MEMBERSHIP_IN_PROJECT` (định danh) | `PROJECT_MEMBER.project_id` |
| `SUBMITS` | `APPLICATION.applicant_id` |
| `APPLIES_FOR` | `APPLICATION.position_id` |
| `REVIEWS` | `APPLICATION.processed_by` (cho phép trống) |
| `RECORDS_STATUS_OF` | `PROJECT_STATUS_HISTORY.project_id` |
| `CHANGED_BY` | `PROJECT_STATUS_HISTORY.changed_by` |
| `TRANSFERS_OWNERSHIP_OF` | `PROJECT_HANDOVER.project_id` |
| `INITIATED_BY` | `PROJECT_HANDOVER.from_user_id` |
| `ADDRESSED_TO` | `PROJECT_HANDOVER.to_user_id` |

**Thuộc tính suy diễn (không lưu cột)** — PDF §2.5, tr. 8:
- `progress_percent` = số task `done` / tổng số task × 100%; chưa có task → chưa xác định; mỗi task trọng số bằng nhau.
- `remaining_slots` = `slots` − số người đang đảm nhiệm hợp lệ (`ended_at IS NULL` **và** thành viên có `left_at IS NULL`).

**Nhận xét khi đọc hình `ERD.png` (người phân tích):**
- Hình khớp với PDF: đủ 10 thực thể, 6 quan hệ N–N, các quan hệ định danh `MEMBERSHIP_*` vẽ thoi đôi, hai elip nét đứt (`progress_percent`, `remaining_slots`). Dòng ghi chú cuối hình lặp lại các quy tắc trong hộp PDF tr. 2.
- Hình **không ghi số bản số (1, N, M) trên cạnh**; bản số chỉ suy ra từ **mũi tên** (hướng về phía "một") và đường đôi/đơn. Do đó các quy tắc "tối thiểu/tối đa" cần đọc kèm PDF; không nên coi riêng hình là đặc tả đầy đủ.
- `POSITION_ASSIGNMENT` và `TASK_ASSIGNMENT` được vẽ là quan hệ **giữa `PROJECT_MEMBER` và `POSITION`/`TASK`** (không phải giữa `USERS` và `POSITION`/`TASK`). Khi ánh xạ sang bảng, PDF chọn dùng khóa `(user_id, position_id)` và `(task_id, user_id)` (xem 5.3).
- `PROJECT_STATUS_HISTORY` vẽ 2 quan hệ tới `USERS`/`PROJECT`; `PROJECT_HANDOVER` có 3 (`TRANSFERS_OWNERSHIP_OF`, `INITIATED_BY`, `ADDRESSED_TO`).

### 5.2. Lược đồ quan hệ và chuẩn hóa — PDF §3–§5 (tr. 10–21) **[Thiết kế]**

- Quy tắc ánh xạ ERD → quan hệ (PDF Bảng 8, tr. 10): 10 thực thể → 10 bảng; 6 N–N → 6 bảng; 13 quan hệ 1–N → khóa ngoại. **Tổng cộng 16 bảng.**
- Kiểm tra 1NF, 2NF, 3NF, BCNF dựa trên tập phụ thuộc hàm đã công bố: **cả 16 bảng đạt BCNF** (PDF §4.8, Bảng 11, tr. 14–15). Cảnh báo của chính PDF: kết luận chỉ đúng *theo các phụ thuộc hàm đã công bố*; các điều kiện như "một owner đang hoạt động" là **ràng buộc có điều kiện**, không phải phụ thuộc hàm (PDF §4.1, tr. 12).
- Chủ ý **không lặp `project_id`** trong `POSITION_ASSIGNMENT` và `TASK_ASSIGNMENT` để giữ 3NF (PDF §3.2 bước 4, tr. 10; §4.6, tr. 13–14); đổi lại, quy tắc "người nhận cùng dự án" phải kiểm tra bằng truy vấn/trigger/giao dịch.

### 5.3. Cấu trúc bảng thực tế — `database/schema/001_create_tables.sql` **[Đã triển khai]**

16 bảng, 25 khóa ngoại, 3 partial unique index, 18 chỉ mục FK thường. Đối chiếu với PDF §5 (Bảng 12–14, tr. 15–21):

| Bảng | Khóa chính | Khóa ngoại | Ràng buộc đáng chú ý trong Schema |
|------|-----------|-----------|-----------------------------------|
| `users` | `id` (identity) | — | `UNIQUE(email)`; `password_hash TEXT NOT NULL` |
| `domain` | `id` | — | `UNIQUE(name)` |
| `skill` | `id` | — | **không** unique trên `name` (giống PDF, xem mục 12) |
| `skill_domain` | `(skill_id, domain_id)` | skill, domain | — |
| `user_skill` | `(user_id, skill_id)` | users, skill | `level BETWEEN 1 AND 5` |
| `project` | `id` | `creator_id`→users | `status` ∈ 5 giá trị, mặc định `planning`; `last_activity_at` mặc định `CURRENT_TIMESTAMP` |
| `project_domain` | `(project_id, domain_id)` | project, domain | — |
| `position` | `id` | `project_id`→project | `slots > 0`; `status` ∈ {open, closed}; `closed_at` khớp `status` và `≥ created_at` |
| `position_skill_requirement` | `(position_id, skill_id)` | position, skill | `min_level BETWEEN 1 AND 5` |
| `project_member` | `(project_id, user_id)` | project, users | `role` ∈ {owner, member}; `left_at ≥ joined_at`; **partial unique `uq_project_active_owner`** (1 owner đang hoạt động/dự án) |
| `position_assignment` | `(user_id, position_id)` | users, position | `ended_at ≥ started_at` |
| `application` | `id` | position, applicant→users, `processed_by`→users (nullable) | `status` ∈ 4 giá trị; `ck_application_decision` (accepted/rejected bắt buộc có `processed_by` + `decided_at`; pending/withdrawn phải trống); **partial unique `uq_application_pending`** |
| `task` | `id` | `project_id`→project | `status` ∈ 3 giá trị; `ck_task_completed_at` (done ⇔ có `completed_at`); `updated_at ≥ created_at` |
| `task_assignment` | `(task_id, user_id)` | task, users | `unassigned_at ≥ assigned_at` |
| `project_status_history` | `id` | project, `changed_by`→users | `old_status`/`new_status` thuộc 5 giá trị; **`old_status <> new_status`** |
| `project_handover` | `id` | project, `from_user_id`, `to_user_id`→users | `from_user_id <> to_user_id`; `status` ∈ 4 giá trị; `ck_handover_decision`; **partial unique `uq_handover_pending`** |

**Kết quả đối chiếu Schema ↔ PDF:** tên bảng, cột, khóa, các CHECK và 3 partial unique index **khớp** với PDF §5.1–5.3. Điểm khác duy nhất tôi thấy: Schema có thêm `CHECK (old_status <> new_status)` cho `project_status_history` mà PDF Bảng 14 không liệt kê (không mâu thuẫn, chỉ chặt hơn).
**Chưa kiểm chứng:** tôi chưa chạy script trên PostgreSQL thật (không thuộc phạm vi cho phép), nên chưa xác nhận script chạy không lỗi.

### 5.4. Quy tắc chưa được Schema thực thi — **[Thiết kế] + [Chưa triển khai]**

Chính Schema (chú thích cuối file) và PDF §6.4 (tr. 22) thừa nhận các quy tắc sau cần trigger/hàm/giao dịch:

1. Mỗi dự án và kỹ năng phải có ≥ 1 lĩnh vực.
2. Mỗi dự án phải có **đúng một** owner sau mỗi giao dịch (partial unique index chỉ chặn "nhiều hơn một", không chặn "không có").
3. Số người đang đảm nhiệm không vượt `slots`, kể cả duyệt đồng thời.
4. Thành viên, vị trí và task phải cùng dự án (`position_assignment`, `task_assignment`).
5. Quyền của người duyệt đơn và người thao tác.
6. Cập nhật trạng thái dự án và ghi lịch sử trong cùng giao dịch.
7. Ngày kết thúc không trước ngày bắt đầu (đã có CHECK mức dòng; phần liên bảng chưa có).
8. Khi rời dự án phải kết thúc đảm nhiệm/phân công còn hiệu lực.
9. Gợi ý `last_activity_at` được cập nhật theo quy ước FR11.

Các thư mục `database/triggers/`, `functions/`, `views/`, `migrations/` **chỉ có `.gitkeep`** → các quy tắc trên hiện **chưa được viết**. Thư mục `database/queries/` trên nhánh `develop` (từ PR #3, commit `b4474ee`) có thêm `003_validate_constraints.sql`; theo các dòng chú thích đầu file, đây là script kiểm thử các ràng buộc của `001_create_tables.sql` và ghi nhận các quy tắc nghiệp vụ chưa kiểm thử là `NOT_TESTED`. Nội dung chi tiết của file này **chưa được phân tích** trong tài liệu này.

### 5.5. Dữ liệu mẫu — `database/seeds/002_sample_data.sql` **[Đã triển khai]**

5 người dùng giả (`*.demo@example.com`), 3 lĩnh vực, 6 kỹ năng, 2 dự án (`SkillBridge Demo` đang `active`, `Community Campaign Demo` đang `paused`), 3 vị trí, 5 đơn ứng tuyển (đủ 4 trạng thái), 4 task, 5 phân công task, 3 dòng lịch sử, 1 bàn giao `pending`. Script chạy trong một giao dịch, từ chối chạy lần hai nếu đã có user demo. Tất cả dùng chung một `password_hash` bcrypt ví dụ; chú thích trong file khẳng định đây không phải thông tin đăng nhập.

### 5.6. Lịch sử tham gia/đảm nhiệm — hạn chế thiết kế đã biết (PDF §6.1, tr. 22)

`project_member`, `position_assignment`, `task_assignment` chỉ lưu **một dòng cho mỗi cặp**. Khi tái tham gia/được giao lại thì cập nhật mốc thời gian trên dòng cũ; **không giữ được nhiều đợt trước đó**. `application`, `project_handover`, `project_status_history` có `id` riêng nên lưu được nhiều sự kiện.

---

## 6. Kiến trúc Backend và Frontend

### 6.1. Backend — **[Thiết kế] (khung) + [Chưa triển khai] (logic)**

**Đã có:** `backend/pom.xml`; lớp `ProjectCollabApplication` (`@SpringBootApplication`); `application.yml`/`application-dev.yml`; các package rỗng theo tính năng.

**Cấu trúc package** (`com.projectcollab`, package-by-feature) — `backend/README.md`:

| Package | Mục đích | Hiện trạng |
|---------|----------|-----------|
| `config`, `security` | Cấu hình CORS/bean, Spring Security + JWT | Chỉ `.gitkeep` |
| `common/exception`, `common/response`, `common/util` | Lớp dùng chung | Chỉ `.gitkeep` |
| `auth`, `user`, `skill` | Xác thực, hồ sơ, kỹ năng | Chỉ `.gitkeep` |
| `project`, `position`, `application` | Dự án (gồm entity `Project`), vị trí, đơn ứng tuyển | Chỉ `.gitkeep` |
| `member`, `task`, `handover` | Thành viên, công việc/tiến độ, bàn giao | Chỉ `.gitkeep` |

**Chủ sở hữu module theo phân công (mục 8):**

| Package | Chủ sở hữu | Trạng thái |
|---------|-----------|------------|
| `auth`, `user`, `skill`, `project`, `position`, `application`, `security`, `config` | Member 2 (GL) | Đã quyết định |
| `member`, `task`, `handover` | Member 3 (Liu) | Đã quyết định |
| Logic chuyển trạng thái dự án; entity và logic lịch sử trạng thái | Member 3 | Đã quyết định (không nằm trong package nào hiện có; `Project` vẫn thuộc Member 2) |
| `ProjectMember`, `PositionAssignment` (entity, repository, vòng đời) | Member 3 | Đề xuất |
| API tiến độ | Member 3 | Đề xuất |
| `common/exception`, `common/response` (kèm `GlobalExceptionHandler`, error code, response lỗi) | Member 2 (cấu trúc dùng chung ban đầu); Member 3 khai báo exception nghiệp vụ module mình | Đề xuất; `GlobalExceptionHandler` chưa tồn tại |
| `common/util` | Chưa có chủ sở hữu | Chưa xác nhận |
| Package `history` cho lịch sử trạng thái | Member 3 | Đề xuất; **chưa tồn tại** và chưa được tạo |

Giữa hai module có tính phụ thuộc hai chiều: tạo dự án và duyệt đơn (Member 2) cần tạo thành viên/phân công do Member 3 quản lý, còn `member` (Member 3) cần entity `project`, `position`, `user` của Member 2 — xem 8.6 mục 1.

**Tích hợp giữa module — [Đề xuất]:** dùng interface/contract công khai tách khỏi entity và repository nội bộ; không truy cập repository nội bộ của module khác; không phụ thuộc trực tiếp giữa entity (tham chiếu bằng `id`); trao đổi bằng DTO; giao dịch do module điều phối mở và contract của module kia tham gia, rollback toàn bộ khi một bước lỗi. Vị trí package đề xuất dựa trên quy ước hiện có (`backend/README.md`): phương án A là interface trong sub-package `service` của module cung cấp, phương án B là sub-package `api` mới (cần cập nhật quy ước). Cả hai **chưa được tạo**. Chi tiết: `docs/TEAM_WORKFLOW.md` 2.9–2.11.

Quy ước dự kiến: mỗi package có `controller`, `service`, `repository`, `entity`, `dto` (chưa tạo).
Thư mục test `backend/src/test/java/com/projectcollab/` chỉ có `.gitkeep` → **chưa có test nào**.

**Lưu ý vận hành:** Spring Security có trong classpath, nhưng chưa có cấu hình → theo `backend/README.md`, **mặc định mọi endpoint yêu cầu xác thực**. Không có `spring-boot-starter-actuator` → chưa có health endpoint (xem `pom.xml`).

### 6.2. Frontend — **[Thiết kế] (khung) + [Chưa triển khai] (tính năng)**

**Đã có (`frontend/src`):**
- `main.tsx`: bọc `<App/>` trong `BrowserRouter` + `React.StrictMode`.
- `App.tsx`: một route `/` hiển thị trang giữ chỗ "Project skeleton is ready. No features implemented yet."
- `services/api.ts`: Axios instance dùng `VITE_API_BASE_URL`; **interceptor gắn JWT còn là `TODO (Member 4)`**.
- Cấu hình Vite (cổng 5173), Tailwind, PostCSS, TypeScript.

**Thư mục rỗng (chỉ `.gitkeep`):** `components/{common,layout,ui}`, `contexts`, `hooks`, `routes`, `types`, `utils`, `pages/{auth,profile,projects,applications,members,tasks}`.

**Chia sẻ giữa Member 4 và 5:** `components/`, `services/`, `routes/`, `contexts/` (auth context + Axios) — `docs/TEAM_WORKFLOW.md` §2.1. Member 4 xây dựng Auth Context, cấu hình Axios instance và interceptor (**[Đã quyết định]**, xem 8.5 mục 6); Member 5 dùng lại các thành phần này và components chung do Member 4 xây dựng. Thư mục `pages/projects` do Member 4 (khám phá) và Member 5 (quản lý) cùng dùng. **[Đề xuất]** chia thành `pages/projects/discovery/` (Member 4: danh sách, tìm kiếm, chi tiết, gửi/rút đơn) và `pages/projects/management/` (Member 5: dự án của tôi, tạo/sửa dự án, vị trí, ứng viên, thành viên, task, tiến độ, bàn giao); hai thư mục con này **chưa tồn tại**. Đề xuất còn trùng với `pages/members`, `pages/tasks` có sẵn trong khung (8.6 mục 8).

---

## 7. Tổng quan API

### 7.1. Trạng thái — **[Thiết kế ở mức đề xuất] + [Chưa triển khai]**

`docs/api/API_CONTRACT.md` ở trạng thái **DRAFT**: tiêu đề ghi rõ đây là các *gợi ý* suy ra từ danh sách tính năng; mọi `TODO` là chưa được nhóm thống nhất. **Toàn bộ request/response body đều là `{"TODO": "define fields"}`.** Chưa có controller nào trong Backend, nên chưa có endpoint thực tế. Tài liệu này **không** tự bổ sung nội dung hợp đồng API.

**Đề xuất chờ nhóm xác nhận (chưa sửa hợp đồng):** hiện `GET /api/projects/{projectId}/progress` nằm trong nhóm Projects (Member 2). Theo đề xuất giao API tiến độ cho Member 3, cần cập nhật `API_CONTRACT.md` để tách rõ hai phạm vi: thông tin cơ bản của dự án (Member 2) và tiến độ dự án (Member 3). Việc cập nhật phải đi qua PR nhỏ có review của một Backend và một Frontend (`CONTRIBUTING.md`). Đề xuất còn thêm thống kê sức chứa vị trí `capacity`, `filled`, `available` vào API tiến độ (ánh xạ: `position.slots`; số `position_assignment` có `ended_at IS NULL` và thành viên `left_at IS NULL`; `capacity - filled`). Tên khác `slots`/`remaining_slots` trong PDF nên cần xác nhận (8.6 mục 6). Cũng chưa có endpoint cho đổi trạng thái dự án (Member 3) — xem 7.3 và 8.6. Định dạng response chung và error body vẫn `TODO` trong hợp đồng, cần chốt trước khi cài đặt `GlobalExceptionHandler` (8.6 mục 5).

**Các quy ước chung vẫn là `TODO`:** tiền tố đường dẫn (`/api` hay `/api/v1`), cổng, thời hạn/refresh token, khung phản hồi chung, định dạng lỗi, phân trang/sắp xếp. Đã nêu: JSON, `Authorization: Bearer <token>`, bảng mã lỗi 400/401/403/404/409/500.

### 7.2. Danh sách endpoint đã được đề xuất (32 endpoint, chỉ liệt kê)

| Nhóm | Endpoint đề xuất | Xác thực ghi trong draft |
|------|------------------|--------------------------|
| Auth (3) | `POST /api/auth/register`, `POST /api/auth/login`, `GET /api/auth/me` | Public / Public / Required |
| Users (3) | `GET /api/users/{userId}`, `PUT /api/users/me`, `GET /api/users` (ghi "decide if needed") | TODO / Required / TODO |
| Skills (3) | `GET /api/skills`, `GET`+`PUT /api/users/me/skills` | TODO / Required |
| Projects (5) | `POST`, `GET` (tìm/lọc), `GET /{id}`, `PUT /{id}`, `GET /{id}/progress` dưới `/api/projects` | Required / TODO / TODO / Owner / TODO |
| Positions (4) | `POST`, `GET`, `PUT`, `DELETE` dưới `/api/projects/{projectId}/positions` (DELETE ghi "delete / close – TODO") | Owner (trừ GET: TODO) |
| Applications (4) | `POST /api/positions/{positionId}/applications`, `GET /api/users/me/applications`, `GET /api/projects/{projectId}/applications`, `PATCH /api/applications/{applicationId}/review` | Required / Required / Owner / Owner |
| Members (3) | `GET`, `PATCH /{memberId}` (đổi vị trí), `DELETE /{memberId}` dưới `/api/projects/{projectId}/members` | TODO / Owner / Owner |
| Tasks (5) | `POST`, `GET`, `PUT /{taskId}`, `PATCH /{taskId}/assignee`, `PATCH /{taskId}/status` dưới `/api/projects/{projectId}/tasks` | Required hoặc TODO |
| History (1) | `GET /api/projects/{projectId}/history` | TODO |
| Handover (1) | `POST /api/projects/{projectId}/handover` | Owner |

### 7.3. Chức năng đã có yêu cầu nhưng **không thấy endpoint tương ứng** trong draft

Đây là nhận xét đối chiếu của người phân tích, chưa phải quyết định của nhóm (chi tiết ở mục 12):
FR06 rút đơn; FR12 chấp nhận/từ chối/hủy bàn giao; đổi trạng thái dự án (chỉ có thể ngầm trong `PUT /projects/{id}`); danh sách lĩnh vực (`domain`); đăng xuất; tìm kiếm vị trí độc lập (FR05); cảnh báo đình trệ (FR11); thêm/kết thúc vị trí đảm nhiệm của thành viên (có thể là `PATCH .../members/{memberId}`).

---

## 8. Phân công trách nhiệm các thành viên

Nguồn: phân công chính thức do nhóm cung cấp (2026-11-05) và các quyết định/đề xuất bổ sung cùng ngày, đã được ghi vào `docs/TEAM_WORKFLOW.md`. Nhãn dùng trong mục này:

- **[Đã quyết định]**: đã chốt, áp dụng ngay.
- **[Đề xuất]**: chờ cả nhóm xác nhận.
- **[Chưa xác nhận]**: chưa có bằng chứng đủ rõ.

### 8.1. Bảng phân công và đối chiếu tên

| # | Tên gọi | Vai trò | Họ tên do nhóm cung cấp | Trạng thái đối chiếu |
|---|---------|---------|--------------------------|----------------------|
| 1 | Mỡ | Database Developer kiêm Business Analyst | Hoàng Thảo Linh | **[Chưa xác nhận]** |
| 2 | GL | Backend Developer: tài khoản và tuyển dụng | Thái Thị Gia Linh | **[Chưa xác nhận]** |
| 3 | Liu | Backend Developer: cộng tác và quản lý dự án | Trần Lê Thảo Linh | **[Chưa xác nhận]** (có bằng chứng gián tiếp ngoài PDF: Git `user.name` = `Liu Tran Le`) |
| 4 | Nguyệt | Frontend Developer kiêm UI/UX | Vũ Thị Ánh Nguyệt | Có bằng chứng trong PDF (tên riêng trùng, PDF chỉ có một người tên này) |
| 5 | Miu | Frontend Developer kiêm Deployment | Trần Đậu Nhật Linh | **[Chưa xác nhận]** |

PDF (trang bìa) chỉ liệt kê họ tên và MSSV, **không chứa tên gọi trong nhóm**, nên không thể xác minh ánh xạ chỉ từ PDF. Đã đối chiếu lại trang bìa PDF ngày 2026-11-05, kết quả không đổi. Chi tiết bằng chứng: `docs/TEAM_WORKFLOW.md` mục 5.

### 8.2. Trách nhiệm theo tầng

**Cơ sở dữ liệu: Member 1 (Mỡ)**
- Nghiệp vụ, requirements, ERD; bảng, kiểu dữ liệu, khóa, ràng buộc, chỉ mục.
- SQL tạo database, dữ liệu mẫu, views, truy vấn báo cáo; script thay đổi cấu trúc (`database/migrations/`).
- Data dictionary, kiểm thử, backup/restore; hỗ trợ kiểm tra tính nhất quán.
- Chốt cấu trúc dữ liệu cùng Member 2 và 3, không tự quyết định thay nghiệp vụ của backend.
- **[Đề xuất]** Trực tiếp quản lý và triển khai trigger, constraints, SQL functions/stored procedures, indexes và ràng buộc liên bảng. Member 2 và 3 xác định quy tắc nghiệp vụ và phối hợp Member 1 (tuyển dụng, duyệt đơn: Member 2; thành viên, rời dự án, bàn giao: Member 3). Không ai tự sửa script database của người khác.
- **[Đề xuất]** Hỗ trợ ràng buộc và kiểm thử CSDL cho việc đóng tuyển dụng khi dự án kết thúc; định nghĩa danh mục mã lỗi ổn định cho trigger/function.

**Backend: Member 2 (GL), tài khoản và tuyển dụng**
- Authentication, Users, Profiles; Skills API và danh mục.
- Projects, Positions, Applications; tìm kiếm, lọc, phân trang, gợi ý vị trí.
- Gửi, rút, xem, xét duyệt đơn; kiểm tra quyền owner.
- Giao dịch tạo dự án, duyệt đơn, thêm thành viên; kiểm thử API và tình huống duyệt đồng thời.
- **[Đã quyết định]** Sở hữu entity `Project` trong package `project`; phụ trách thông tin cơ bản của dự án.
- **[Đề xuất]** Sở hữu quy trình duyệt đơn; khi duyệt (và khi tạo dự án để thêm owner), dùng contract công khai do Member 3 cung cấp để tạo thành viên và phân công vị trí.
- **[Đề xuất]** Sở hữu logic đóng `Position` và xử lý `Application` `pending` khi dự án `completed`/`cancelled`, cung cấp qua contract cho Member 3.
- **[Đề xuất]** Cung cấp dữ liệu vị trí qua contract/query công khai cho API tiến độ.
- **[Đề xuất]** Sở hữu cấu trúc dùng chung ban đầu: `common/exception`, `common/response`, `GlobalExceptionHandler`, quy chuẩn error code và response lỗi.
- Package: `auth`, `user`, `skill`, `project`, `position`, `application`, `security`, `config`.

**Backend: Member 3 (Liu), cộng tác và quản lý dự án**
- Thành viên, đảm nhiệm/thôi vị trí, rời dự án; công việc, giao việc, cập nhật trạng thái.
- Kiểm tra thành viên đang hoạt động và thuộc đúng dự án; xử lý phân công khi rời dự án.
- `last_activity_at` và dữ liệu cảnh báo đình trệ.
- Bàn giao: gửi, hủy, chấp nhận, từ chối; giao dịch chuyển owner (đúng một owner hoạt động).
- Kết nối views và truy vấn của Member 1; kiểm thử cộng tác, rời dự án, bàn giao, rollback.
- **[Đã quyết định]** Logic chuyển trạng thái dự án; entity và logic ghi nhận lịch sử trạng thái. Thống nhất với Member 2 về trường, enum và phương thức tương tác với `Project`.
- **[Đề xuất]** Entity, Repository, logic vòng đời `ProjectMember` và `PositionAssignment`; cung cấp contract tạo thành viên/phân công cho Member 2.
- **[Đề xuất]** API tiến độ dự án, kèm thống kê sức chứa vị trí `capacity`, `filled`, `available`.
- **[Đề xuất]** Khi dự án kết thúc, gọi contract của Member 2 để đóng tuyển dụng trong cùng giao dịch; khai báo exception nghiệp vụ của module mình.
- Package: `member`, `task`, `handover`. **[Đề xuất]** package `history` cho lịch sử trạng thái, **chưa tồn tại**; chưa được tạo.
- **[Đã quyết định]** Branch: `feature/member-management`, `feature/member-leaving`, `feature/project-progress`, `feature/project-history`, `feature/owner-handover`, và `feature/task-management` (branch backend; không gộp code frontend của Member 5). Tạo từ `develop`, PR vào `develop`.

**Frontend: Member 4 (Nguyệt), UI/UX và luồng người dùng tìm dự án**
- Luồng màn hình, giao diện chung, components dùng chung.
- Đăng ký, đăng nhập, hồ sơ, kỹ năng; gợi ý vị trí, xem đơn; kết nối API thật, xử lý trạng thái giao diện.
- **[Đã quyết định]** Giữ Auth Context, Axios instance và interceptor, cơ chế xác thực dùng chung; Member 5 dùng lại.
- **[Đề xuất]** Sở hữu `pages/projects/discovery/`: danh sách, tìm kiếm, chi tiết dự án; gửi và rút đơn ứng tuyển.

**Frontend: Member 5 (Miu), quản lý dự án và triển khai**
- Giao diện dự án đã tạo/tham gia; quản lý thành viên và vị trí đảm nhiệm; công việc, phân công, tiến độ; cảnh báo, lịch sử, bàn giao.
- Kết nối API của Member 2 và 3; dùng components chung và Auth Context/Axios của Member 4.
- Docker, cấu hình môi trường, CI/CD, triển khai demo; hướng dẫn khởi động và kiểm thử sau triển khai. Không mặc nhiên chịu trách nhiệm sửa mọi lỗi của người khác.
- **[Đề xuất]** Sở hữu `pages/projects/management/`: dự án của tôi, tạo/sửa dự án, quản lý vị trí, ứng viên, thành viên, task, tiến độ và bàn giao.
- **[Đề xuất]** Member 4 và 5 không cùng sửa một page/component khi chưa thống nhất.

### 8.3. Luồng nghiệp vụ theo Member

| Luồng | Backend | Frontend | Giao dịch | Trạng thái |
|-------|---------|----------|-----------|------------|
| Đăng ký, đăng nhập, hồ sơ | Member 2 | Member 4 | — | Đã quyết định |
| Kỹ năng và danh mục | Member 2 | Member 4 | — | Đã quyết định |
| Tạo dự án (FR03) | Member 2 (entity `Project`) | Member 5 | Member 2; thêm owner qua contract của Member 3 | Backend: đã quyết định; frontend: đề xuất |
| Sửa thông tin cơ bản dự án (FR03) | Member 2 | Member 5 | — | Backend: đã quyết định; frontend: đề xuất |
| Vị trí tuyển, yêu cầu kỹ năng (FR04) | Member 2 | Member 5 | — | Backend: đã quyết định; frontend: đề xuất |
| Tìm kiếm, lọc, gợi ý (FR05) | Member 2 | Member 4 | — | Backend: đã quyết định; frontend: đề xuất. Lọc "còn chỗ" cần số người đang đảm nhiệm từ dữ liệu của Member 3 (8.6 mục 6) |
| Gửi, xem, rút đơn (FR06) | Member 2 | Member 4 | — | Backend: đã quyết định; frontend: đề xuất (gửi, rút) |
| Xét duyệt đơn (FR07) | Member 2 | Member 5 (ứng viên) | Duyệt đơn: Member 2; tạo thành viên/phân công qua contract của Member 3 | Đã quyết định (giao dịch); đề xuất (quy trình, contract) |
| Vòng đời `ProjectMember`, `PositionAssignment` (FR07, FR08) | Member 3 | Member 5 | — | Đề xuất |
| Thành viên, đảm nhiệm/thôi vị trí, rời dự án (FR08) | Member 3 | Member 5 | Rời dự án: Member 3 | Đã quyết định |
| Công việc, giao việc, trạng thái task (FR09) | Member 3 | Member 5 | — | Đã quyết định |
| Tiến độ dự án và sức chứa vị trí (FR10) | Member 3 | Member 5 | — | Backend: đề xuất (`capacity`, `filled`, `available`); frontend: đã nêu trong phân công |
| Cảnh báo đình trệ, `last_activity_at` (FR11) | Member 3 | Member 5 | — | Đã quyết định |
| Chuyển trạng thái dự án và lịch sử (FR03, FR12) | Member 3 (`Project` thuộc Member 2) | Member 5 | Member 3 | Phân công: đã quyết định; ma trận chuyển trạng thái: đề xuất, chưa áp dụng |
| Đóng `Position`, xử lý `Application` `pending` khi dự án kết thúc | Member 2 (Member 3 gọi qua contract) | — | Cùng giao dịch với chuyển trạng thái (Member 3 mở) | Đề xuất; trạng thái cuối của đơn chưa thống nhất |
| Bàn giao owner (FR12) | Member 3 | Member 5 | Chuyển owner: Member 3 | Đã quyết định |

Bảng này chỉ nói *ai chịu trách nhiệm*, không nói chức năng đã làm. Trạng thái triển khai của mọi luồng vẫn là **[Chưa triển khai]** (mục 9).

### 8.4. Quy tắc phối hợp

- Member 1 chốt cấu trúc dữ liệu cùng Member 2 và 3; không tự quyết định thay nghiệp vụ của backend.
- Member 2 và 3 thống nhất API với Member 4 và 5 trước khi triển khai (hợp đồng `docs/api/API_CONTRACT.md`, hiện là bản nháp). Frontend được dùng dữ liệu mẫu trong lúc chờ API.
- Duyệt đơn: Member 2. Rời dự án và bàn giao owner: Member 3.
- **[Đã quyết định]** Không tạo entity `Project` trùng lặp; không tự ý sửa entity thuộc Member khác; Member 2 và 3 thống nhất trường, enum, phương thức tương tác với `Project`.
- **[Đề xuất]** Tích hợp giữa `project`/`application` và `member` qua contract công khai, không truy cập repository nội bộ, không phụ thuộc trực tiếp giữa entity; giao dịch do module điều phối mở, contract của module kia tham gia (`docs/TEAM_WORKFLOW.md` 2.10).
- **[Đề xuất]** Lỗi trigger PostgreSQL được ánh xạ bằng SQLSTATE và tên constraint, không bằng chuỗi thông báo; không trả lỗi SQL nội bộ cho frontend (`docs/TEAM_WORKFLOW.md` 2.11).
- Mỗi người tự kiểm thử và viết báo cáo phần mình; cả nhóm cùng tích hợp và sửa lỗi.
- Quy trình Git (`CONTRIBUTING.md`, `TEAM_WORKFLOW.md` §3): leader tạo issue; API contract đi trước code; nhánh từ `develop`; PR + 1 review; họp tuần ghi `docs/meeting-notes/YYYY-MM-DD.md`; `develop` → `main` chỉ ở mốc demo.

### 8.5. Các quyết định và đề xuất

**8.5a. Từ lượt trước** (đánh số 1–8 giữ nguyên để các mục khác còn tham chiếu được)

| # | Nội dung | Trạng thái |
|---|----------|------------|
| 1 | Trigger, constraints, functions/stored procedures, indexes, ràng buộc liên bảng thuộc Member 1; Member 2, 3 cung cấp quy tắc | **[Đề xuất]** |
| 2 | `Project` thuộc Member 2; chuyển trạng thái, entity và logic lịch sử thuộc Member 3; package `history` | Phân công: **[Đã quyết định]**; package `history`: **[Đề xuất]** |
| 3 | Member 3 sở hữu `ProjectMember`, `PositionAssignment`; Member 2 sở hữu quy trình duyệt đơn; thống nhất transaction boundary | **[Đề xuất]** |
| 4 | Member 3 phụ trách API tiến độ; cập nhật API contract để tách phạm vi (chưa thực hiện) | **[Đề xuất]** |
| 5 | Member 5: tạo/chỉnh sửa dự án, vị trí, ứng viên; Member 4: danh sách, tìm kiếm, chi tiết, gửi/rút đơn | **[Đề xuất]** |
| 6 | Member 4 giữ Auth Context, Axios, interceptor | **[Đã quyết định]** |
| 7 | Năm branch của Member 3 | **[Đã quyết định]** |
| 8 | Ánh xạ tên gọi ↔ họ tên | Xem 8.1 |

**8.5b. Lượt cập nhật hiện tại** (chi tiết: `docs/TEAM_WORKFLOW.md` mục 2.2.1, 2.5, 2.6, 2.9–2.11, 4.1)

| # | Nội dung | Trạng thái |
|---|----------|------------|
| A1 | Ma trận chuyển trạng thái dự án dùng `draft`/`open`: `draft` → `open`, `cancelled`; `open` → `paused`, `completed`, `cancelled`; `paused` → `open`, `completed`, `cancelled`; `completed`, `cancelled` là trạng thái kết thúc | **[Đề xuất]**; **không tương thích** enum thực tế, chưa áp dụng (xem 2.3 mục "Ma trận đề xuất", 8.6 mục 2) |
| A2 | Đóng tuyển dụng khi dự án kết thúc: Member 3 chuyển trạng thái; Member 2 đóng `Position` và xử lý `Application` `pending`; Member 1 hỗ trợ ràng buộc và kiểm thử; cùng một giao dịch | **[Đề xuất]**; trạng thái cuối của đơn `pending` chưa thống nhất |
| A3 | Contract tích hợp công khai giữa `project`/`application` và `member`; không truy cập repository nội bộ; không phụ thuộc trực tiếp giữa entity; xác định transaction boundary và rollback | **[Đề xuất]** |
| A4 | Member 2 sở hữu `common/exception`, `common/response`, `GlobalExceptionHandler`, error code; Member 3 khai báo exception module mình; quy trình chuyển lỗi trigger thành lỗi API | **[Đề xuất]** |
| A5 | API tiến độ của Member 3 kèm `capacity`, `filled`, `available`; Member 2 cung cấp dữ liệu vị trí qua contract/query công khai | **[Đề xuất]** (hợp đồng chưa sửa) |
| A6 | Chia `pages/projects` thành `discovery/` (Member 4) và `management/` (Member 5) | **[Đề xuất]** |
| A7 | `feature/task-management` là branch backend của Member 3, tạo từ `develop`, PR vào `develop`, không gộp code frontend | **[Đã quyết định]** |
| A8 | Ánh xạ tên gọi ↔ họ tên | Chỉ Nguyệt có bằng chứng trong PDF; các dòng khác **[Chưa xác nhận]** (xem 8.1) |

### 8.6. Xung đột với kiến trúc hiện tại và câu hỏi còn mở

Đây là nhận xét của người phân tích dựa trên khung backend, schema, seed, PDF và `API_CONTRACT.md`; chưa phải quyết định của nhóm.

1. **Phụ thuộc vòng có thể xảy ra** giữa `project`/`application` (Member 2) và `member` (Member 3): `project_member` có khóa ngoại tới `project`; tạo dự án phải thêm owner (PDF FR03); duyệt đơn phải thêm hoặc khôi phục thành viên và ghi vị trí đảm nhiệm trong cùng giao dịch (PDF FR07). Đề xuất tách bằng contract công khai vẫn để lại vòng phụ thuộc ở mức package (`project` ↔ `member`), vì cả hai chiều đều có contract. Quy ước hiện có (`backend/README.md`) chỉ có sub-package `controller`, `service`, `repository`, `entity`, `dto`; `pom.xml` không có công cụ kiểm tra kiến trúc. Vị trí interface đề xuất: phương án A (interface trong `service` của module cung cấp) hoặc B (sub-package `api` mới). *Hiện chưa có mã nên đây là nguy cơ, chưa phải lỗi.*
2. **Ma trận trạng thái không khớp enum:** schema, PDF và seed dùng `planning`, `active`, `paused`, `completed`, `cancelled`; ma trận đề xuất dùng `draft`, `open`. `open` còn là trạng thái của `position`. PDF chưa quy định chuyển trạng thái hợp lệ; schema chỉ có `CHECK (old_status <> new_status)`. Đổi enum cần Member 1 sửa schema bằng migration; không làm trong phạm vi tài liệu này.
3. **Trạng thái cuối của `Application` `pending` chưa xác định.** PDF chỉ nói đơn không được chấp nhận khi dự án kết thúc. Theo `ck_application_decision`: `rejected` cần `processed_by` và `decided_at`; `withdrawn` cần để trống cả hai và sai nghĩa; giữ `pending` thì đơn treo; giá trị mới cần đổi schema (`ck_application_status` chỉ có 4 giá trị). Các `position_assignment` đang hiệu lực khi dự án kết thúc, và việc `paused` có đóng vị trí hay không, PDF không nêu.
4. **Tài khoản hệ thống:** PDF (§5.1.15, tr. 19) nói thay đổi tự động dùng tài khoản hệ thống, nhưng `project_status_history.changed_by` và `application.processed_by` (khi `accepted`/`rejected`) tham chiếu `users` và schema/seed không có tài khoản hệ thống.
5. **Đồng thời và lỗi từ CSDL:** duyệt đơn (Member 2) có thể chạy đồng thời với chuyển dự án sang `completed`/`cancelled` (Member 3), cần cơ chế khóa dùng chung. Quy tắc liên bảng có thể bị viết hai lần (trigger của Member 1 và giao dịch của Member 2/3) hoặc không ai viết. `API_CONTRACT.md` còn `TODO` cho "Common response envelope" và "Common error body", nên `GlobalExceptionHandler` và mã lỗi chưa thể cài đặt trước khi chốt hợp đồng. `GlobalExceptionHandler` chưa tồn tại.
6. **API tiến độ:** hợp đồng nháp xếp `GET /api/projects/{projectId}/progress` vào nhóm Projects; đề xuất sửa hợp đồng chưa thực hiện. Tên `capacity`/`filled`/`available` khác `slots`/`remaining_slots` trong PDF và schema. `filled` lấy từ `position_assignment` (đề xuất thuộc Member 3), còn lọc "còn chỗ" của FR05 (Member 2) cũng cần giá trị này nên phát sinh phụ thuộc theo chiều ngược lại. PDF FR10 còn yêu cầu đếm người kiêm nhiều vị trí là một thành viên.
7. **Endpoint chưa có / trùng phạm vi:** hợp đồng nháp chưa có endpoint đổi trạng thái dự án; `PUT /api/projects/{projectId}` (Member 2) có thể chứa cả đổi trạng thái.
8. **Frontend:** khung hiện có `pages/members`, `pages/tasks`, `pages/applications`; đề xuất `management/` bao gồm thành viên và task nên trùng với hai thư mục trên. `App.tsx`, `routes/`, `components/` là điểm dùng chung dễ xung đột. Member 5 phụ thuộc Auth Context, Axios và components do Member 4 xây dựng, nên có nguy cơ bị chặn tiến độ.
9. **Package và sub-package mới:** `history`, `api`, `GlobalExceptionHandler`, `discovery/`, `management/` đều **chưa tồn tại** và chưa được tạo.
10. **Branch:** `feature/task-management` nay là branch backend của Member 3. Phần giao diện công việc của Member 5 cần branch riêng, tên chưa xác định; các branch dùng chung còn lại trong danh sách cũ chưa được tách.

---

## 9. Trạng thái triển khai hiện tại

### 9.1. Bảng tổng hợp theo 4 nhãn

| Hạng mục | Thiết kế | Triển khai | Ghi chú / nguồn |
|----------|:-------:|:----------:|-----------------|
| Yêu cầu FR01–FR12, BR1–BR14, NFR | ✔ | — | PDF §1 |
| ERD Chen (10 thực thể, 6 N–N, 13 1–N) | ✔ | ✔ (ảnh) | `ERD.png`, PDF §2 |
| Lược đồ 16 bảng + chuẩn hóa BCNF | ✔ | ✔ | PDF §3–5; Schema |
| Script tạo bảng, CHECK, 3 partial unique, 18 index | ✔ | ✔ | Schema |
| Dữ liệu mẫu | — | ✔ | Seed |
| Docker Compose cho PostgreSQL | — | ✔ | `docker-compose.yml` |
| Tự động nạp schema/seed khi khởi động Docker | — | ✘ | Không có mount `docker-entrypoint-initdb.d` — phải chạy tay (`CLAUDE.md`) |
| Trigger / function / view / migration | ✔ (mô tả quy tắc) | ✘ | Thư mục chỉ có `.gitkeep` |
| Khung Spring Boot, `pom.xml`, YAML cấu hình | ✔ | ✔ | `backend/` |
| Entity JPA, Repository, Service, Controller | ✔ (cấu trúc) | ✘ | Package rỗng |
| Cấu hình Spring Security, JWT, CORS, xử lý lỗi chung | ✔ (biến env) | ✘ | `security/`, `config/`, `common/` rỗng |
| Test backend | — | ✘ | `src/test` chỉ `.gitkeep` |
| Khung React/Vite/Tailwind, Axios instance | ✔ | ✔ | `frontend/` |
| Trang, route, context, component thực tế | ✔ (cấu trúc) | ✘ | Chỉ trang giữ chỗ |
| JWT interceptor ở Frontend | ✔ (TODO) | ✘ | `services/api.ts` |
| API contract | ✔ (draft) | ✘ | Toàn `TODO` |
| CI GitHub Actions | — | ✔ | `ci.yml` |
| Dockerfile Backend/Frontend, triển khai | — | ✘ | `deployment/README.md`: "Nothing is configured here yet" |
| Postman collection | — | ✘ | `postman/README.md`: "No collection has been created yet" |
| Gợi ý phù hợp (FR05), cảnh báo đình trệ (FR11), tiến độ (FR10) | ✔ | ✘ | Không có view/service |
| Bàn giao owner (FR12), duyệt đơn nguyên tử (FR07) | ✔ | ✘ | Cần giao dịch + trigger |

### 9.2. Nhận xét

- Repository đang ở mức **skeleton**: phần hoàn chỉnh duy nhất là *thiết kế CSDL* (PDF + ERD + Schema + Seed) và *khung dự án*. Điều này khớp với mô tả trong `CLAUDE.md` và `README.md`.
- Git: nhánh cục bộ chỉ có `main`; trên remote có `develop` và `feature/database-schema`. Các file `CLAUDE.md`, `ERD.png` và PDF hiện **chưa được commit** (trạng thái `??` khi bắt đầu phân tích).
- Các thư mục tài liệu `requirements/`, `architecture/`, `database/schema/`, `database/data-dictionary/`, `meeting-notes/` trống: theo yêu cầu, **không coi là lỗi** và **không** được dùng làm bằng chứng chức năng chưa triển khai.

---

## 10. Các chức năng còn thiếu

Tất cả là **[Chưa triển khai]**, sắp theo phụ thuộc kỹ thuật (người phân tích đề xuất thứ tự, không phải kế hoạch của nhóm).

**Tầng CSDL (Member 1):**
- Trigger/hàm cho các quy tắc ở 5.4 (≥ 1 lĩnh vực, đúng 1 owner, không vượt `slots`, cùng dự án, kết thúc đảm nhiệm khi rời dự án).
- Hàm/view cho `progress_percent`, `remaining_slots`, điểm phù hợp kỹ năng, cảnh báo đình trệ.
- Chỉ mục phục vụ tìm kiếm (PDF §1.7) — hiện chỉ có chỉ mục FK.

**Backend (Member 2: tài khoản và tuyển dụng; Member 3: cộng tác và quản lý dự án — xem mục 8):**
- Entity/Repository/Service/Controller cho cả 12 nhóm chức năng; Spring Security + JWT + CORS; mã hóa mật khẩu (`PasswordEncoder`); xử lý lỗi chung và khung phản hồi.
- Logic nghiệp vụ nguyên tử: duyệt đơn (FR07), rời dự án (FR08), đổi trạng thái + ghi lịch sử (FR12), bàn giao owner.
- Cập nhật `last_activity_at` theo quy ước FR11; cấu hình ngưỡng cảnh báo.
- Test đơn vị/tích hợp.

**Frontend (Member 4, 5):**
- Auth context, interceptor JWT, router, layout; các trang auth, profile/kỹ năng, khám phá/tìm kiếm, chi tiết dự án, ứng tuyển, duyệt ứng viên, thành viên, task, lịch sử, bàn giao.

**Hạ tầng (Member 5):**
- Dockerfile Backend/Frontend, cấu hình môi trường triển khai, script nạp schema/seed, Postman collection.

---

## 11. Những tài liệu còn thiếu

> Chỉ liệt kê và đề xuất; **không** tự tạo nội dung. Các thư mục dưới đây đã được tạo sẵn nhưng chưa có tài liệu (`docs/README.md` mô tả mục đích từng thư mục).

| Tài liệu | Thư mục dự kiến | Lý do cần | Ưu tiên đề xuất |
|----------|-----------------|-----------|:---:|
| API contract đầy đủ (field, mã lỗi, phân quyền, phân trang) | `docs/api/API_CONTRACT.md` (đã có draft) | Frontend và Backend cần thống nhất trước khi code (quy tắc dự án) | Cao |
| Từ điển dữ liệu (mô tả từng bảng/cột) | `docs/database/data-dictionary/` | `database/README.md` yêu cầu "Document each table" | Cao |
| Đặc tả yêu cầu/use case/user story dạng độc lập | `docs/requirements/` | PDF là báo cáo môn học; chưa có use case chính thức | Trung bình |
| Quy tắc chuyển trạng thái (dự án, đơn, bàn giao, task) | `docs/requirements/` hoặc `docs/architecture/` | PDF chưa có ma trận chuyển hợp lệ; ma trận đề xuất 2026-11-05 chưa tương thích enum (xem 2.3) | Cao |
| Tài liệu kiến trúc + quyết định kiến trúc (cách xử lý giao dịch/trigger, nơi đặt logic gợi ý, lưu JWT) | `docs/architecture/` | Chưa có quyết định về nơi thực thi quy tắc liên bảng | Cao |
| Tài liệu contract tích hợp giữa module (interface, DTO, transaction boundary) | `docs/architecture/` | Cần thống nhất Member 2 – Member 3 trước khi cài đặt (`TEAM_WORKFLOW.md` 2.10) | Cao |
| Danh mục mã lỗi CSDL ↔ mã lỗi API | `docs/database/` hoặc `docs/architecture/` | Cần cho `GlobalExceptionHandler` (`TEAM_WORKFLOW.md` 2.11) | Trung bình |
| Xuất tài liệu schema | `docs/database/schema/` | Đã mô tả trong `docs/README.md` nhưng chưa có | Thấp |
| Ghi chú họp | `docs/meeting-notes/` | Quy ước `YYYY-MM-DD.md`; cần cho việc chốt các `TODO` ở TEAM_WORKFLOW | Trung bình |
| Bảng ánh xạ tên gọi trong nhóm (Mỡ, GL, Liu, Nguyệt, Miu) ↔ họ tên đầy đủ trong PDF | `docs/TEAM_WORKFLOW.md` | Phân công Member # ↔ tên gọi đã có; đối chiếu họ tên: 1 dòng có bằng chứng rõ, 1 dòng gián tiếp, 3 dòng chưa xác nhận (xem 8.1) | Thấp |
| Hướng dẫn nạp schema/seed và kiểm thử thứ tự chạy | `database/README.md` (cập nhật) | README hiện nói "no SQL scripts yet" (đã lỗi thời) | Cao |
| Kế hoạch triển khai/môi trường | `deployment/README.md` | Hiện chỉ ghi `TODO (Member 5)` | Thấp |
| Chiến lược kiểm thử (Backend/Frontend/CI) | `docs/architecture/` | Chưa có test, CI chưa kiểm tra gì đáng kể | Trung bình |

---

## 12. Các điểm chưa thống nhất hoặc có nguy cơ phát sinh lỗi

Mỗi mục: **mức độ** (Cao/TB/Thấp — đánh giá của người phân tích), nội dung, căn cứ, và đề xuất câu hỏi.

### 12.1. Mâu thuẫn / lỗi thời giữa các tài liệu

| # | Mức | Phát hiện | Căn cứ |
|---|:---:|-----------|--------|
| A1 | TB | `database/README.md` ghi "Currently there are no SQL scripts yet" nhưng repo đã có `001_create_tables.sql` và `002_sample_data.sql`. | `database/README.md` (dòng cuối) so với `database/schema/`, `database/seeds/` |
| A2 | Thấp | Quy ước đặt tên trong `database/README.md` ("one purpose per file", `001_create_users.sql`, `002_create_projects.sql`…) khác thực tế: một file tạo cả 16 bảng, và seed đánh số `002` nằm ở thư mục khác. Thứ tự chạy phụ thuộc vào đọc hướng dẫn. | `database/README.md` so với tên file thực tế |
| A3 | Thấp | Đề bài phân tích ghi PDF tên `Nhóm_9_bài phân tích và thiết kế CSDL.pdf`, tên thực tế trong repo là `bài phân tích và thiết kế CSDL.pdf` (không có tiền tố "Nhóm_9"). | `docs/reports/` |
| A4 | TB | `API_CONTRACT.md` gợi ý "Create a task (TODO: who is allowed?)" nhưng PDF FR09 đã nêu: owner tạo/sửa/phân công; owner và người được giao cập nhật trạng thái. Nên đồng bộ. | `API_CONTRACT.md` mục 8; PDF §1.5 FR09 |
| A5 | TB | `PATCH .../tasks/{taskId}/assignee` (số ít) so với thiết kế một task giao được **nhiều** thành viên (`task_assignment` N–N). | `API_CONTRACT.md`; PDF FR09; Schema |
| A6 | TB | Draft có `DELETE .../positions/{positionId}` ghi "Delete / close (TODO)", trong khi BR12 cấm xóa cứng dữ liệu được lịch sử tham chiếu và thiết kế có trạng thái `closed`. | `API_CONTRACT.md` mục 5; PDF BR12 |
| A7 | TB | Draft `DELETE .../members/{memberId}` chỉ cho owner; FR08 cho phép thành viên **tự rời** dự án (ghi `TODO: also allow leaving?`) và yêu cầu owner bàn giao trước khi rời. | `API_CONTRACT.md` mục 7; PDF FR08 |
| A8 | TB | Draft không có endpoint cho các nghiệp vụ nêu ở 7.3 (rút đơn, phản hồi bàn giao, đổi trạng thái dự án, danh mục lĩnh vực…). | `API_CONTRACT.md` đối chiếu PDF FR02, FR06, FR12 |
| A9 | Thấp | Tiền tố URL: draft dùng `/api/...` trong khi mục Conventions ghi `TODO: /api/v1`. | `API_CONTRACT.md` |
| A10 | Thấp | Bản phân công cũ giao `frontend/src/pages/projects` cho cả Member 4 và Member 5. **Đề xuất (2026-11-05):** chia `discovery/` (Member 4) và `management/` (Member 5), chưa tạo; còn trùng `pages/members`, `pages/tasks` có sẵn (8.6 mục 8). | `docs/TEAM_WORKFLOW.md` §2.6 |
| A11 | Thấp | **Đã giải quyết (2026-11-05):** kỹ năng thuộc Member 2 (backend) / Member 4 (frontend); chuyển trạng thái, lịch sử thuộc Member 3 (backend) / Member 5 (frontend); entity `Project` thuộc Member 2. Còn lại: thống nhất trường/enum/phương thức tương tác với `Project`, ma trận chuyển trạng thái và hiệu ứng lan sang vị trí/đơn — xem 8.5 mục 2 và 8.6. (Nội dung gốc: phân công kỹ năng và lịch sử chưa chốt.) | `docs/TEAM_WORKFLOW.md` §1.6, §6 |
| A12 | Cao | Ma trận trạng thái dự án đề xuất dùng `draft`/`open`, trong khi enum thực tế là `planning`/`active`/`paused`/`completed`/`cancelled`; `open` còn là trạng thái của `position`. Không áp dụng; cần nhóm quyết định giữ enum hay đổi qua migration (Member 1). | Schema (`ck_project_status`); PDF §1.6; `docs/TEAM_WORKFLOW.md` §2.2.1 |
| A13 | TB | PDF nhắc "tài khoản hệ thống" cho thay đổi tự động (tr. 19) nhưng schema/seed không có tài khoản hệ thống, trong khi `project_status_history.changed_by` là `NOT NULL`. | PDF §5.1.15; Schema |

### 12.2. Rủi ro kỹ thuật ở tầng CSDL

| # | Mức | Rủi ro | Căn cứ |
|---|:---:|--------|--------|
| B1 | Cao | **Đổi owner trong một giao dịch:** `uq_project_active_owner` là partial unique index (không hoãn kiểm tra được như constraint `DEFERRABLE`). Khi bàn giao, nếu "thăng owner mới" trước khi "hạ owner cũ" thì vi phạm tức thì; cần cập nhật theo đúng thứ tự (hạ trước, thăng sau) — nhưng khi đó có khoảng thời gian trong giao dịch không có owner. *Chưa kiểm chứng bằng chạy thật.* | Schema (`uq_project_active_owner`); PDF FR12, BR2, BR13. Phụ trách: giao dịch chuyển owner thuộc Member 3 |
| B2 | Cao | **Chỉ chặn "nhiều hơn một", không chặn "không có":** dự án có thể tồn tại không owner (ví dụ tạo `project` trước khi tạo `project_member`) nếu thiếu giao dịch/trigger. | Chú thích cuối Schema; PDF §5.3, tr. 21 |
| B3 | Cao | **Duyệt đơn đồng thời vượt `slots`:** chưa có khóa/trigger; hai owner request đồng thời có thể cùng chấp nhận. | PDF BR13, §6.4; chú thích cuối Schema. Phụ trách: giao dịch duyệt đơn và kiểm thử duyệt đồng thời thuộc Member 2 |
| B4 | TB | **Không có FK ép "cùng dự án":** `position_assignment` chỉ tham chiếu `users` và `position`; `task_assignment` chỉ `task` và `users`. Một user ngoài dự án vẫn có thể được ghi nhận nếu code/trigger không kiểm tra. Đây là hệ quả chủ ý của việc loại `project_id` để giữ 3NF. | Schema; PDF §3.2 bước 4, §4.6 |
| B5 | TB | `skill.name` **không UNIQUE** (cả PDF lẫn Schema) → có thể có kỹ năng trùng tên, ảnh hưởng gợi ý/tìm kiếm. Đây có thể là chủ ý hoặc thiếu sót — cần xác nhận. | Schema; PDF §5.1.3 (tr. 16) |
| B6 | TB | `users.email UNIQUE` phân biệt hoa/thường (không dùng `lower(email)`/`citext`): `A@x.com` và `a@x.com` là hai tài khoản. Chưa có CHECK định dạng email. | Schema |
| B7 | TB | Script schema khẳng định `current_database() = 'project_collab'` trong khi `.env.example` cho đổi `POSTGRES_DB`. Nếu đổi tên CSDL, script sẽ ném lỗi. | Schema (khối `DO`); `.env.example` |
| B8 | Thấp | Schema giả định CSDL **rỗng**, chạy một lần; chưa có cơ chế migration (`database/migrations/` rỗng). Sửa schema sau này cần quy ước `V002__*.sql` đã nêu trong `CLAUDE.md` nhưng chưa có công cụ áp dụng (Flyway/Liquibase không có trong `pom.xml`). | `CLAUDE.md`; `pom.xml` |
| B9 | Thấp | Tên bảng/cột `position`, `domain`, `level`, `role` trùng từ khóa SQL (không dành riêng hoàn toàn trong PostgreSQL). Có thể cần `@Table(name = "\"position\"")` hoặc kiểm thử khi viết Entity JPA. *Chưa kiểm chứng.* | Schema |
| B10 | Thấp | Thiết kế một dòng cho mỗi cặp tham gia/đảm nhiệm/giao việc → mất lịch sử các đợt trước (đã được PDF thừa nhận). | PDF §6.1 |
| B11 | Thấp | Seed dùng chung một hash bcrypt "ví dụ công khai" cho cả 5 tài khoản; chú thích nói không phải thông tin đăng nhập, nhưng nếu hash này ứng với mật khẩu đã biết thì các tài khoản demo đăng nhập được bằng mật khẩu đó. Chưa kiểm chứng; nên tránh nạp seed ở môi trường công khai. | Seed (đầu file) |
| B12 | TB | Trạng thái cuối của `application` `pending` khi dự án `completed`/`cancelled` không được PDF quy định; các lựa chọn bị `ck_application_decision` và `ck_application_status` ràng buộc (xem 8.6 mục 3). | PDF §1.6; Schema |

### 12.3. Rủi ro ở Backend / Frontend / vận hành

| # | Mức | Rủi ro | Căn cứ |
|---|:---:|--------|--------|
| C1 | Cao | **CI sẽ gãy khi có test tải Spring context:** `application.yml` yêu cầu `JWT_SECRET` (không mặc định) và profile `dev` yêu cầu `DB_USERNAME`/`DB_PASSWORD` (không mặc định); workflow `ci.yml` không đặt biến môi trường và không dựng PostgreSQL. Hiện CI chạy `mvn verify` không có test nên chưa lộ. | `application.yml`, `application-dev.yml`, `ci.yml` |
| C2 | TB | Mặc định mọi endpoint yêu cầu xác thực (Spring Security) → các chức năng Public (đăng ký, đăng nhập, xem dự án công khai theo FR/Tác nhân "Khách") sẽ trả 401 cho tới khi cấu hình `SecurityFilterChain`. | `backend/README.md`; PDF §1.3 |
| C3 | TB | Chưa quyết định **nơi thực thi quy tắc liên bảng**: trigger CSDL (`database/triggers/`) hay giao dịch ở tầng service. Theo phân công: giao dịch duyệt đơn thuộc Member 2, giao dịch rời dự án và chuyển owner thuộc Member 3 (đã quyết định); trigger, constraint, function, index thuộc Member 1 (**[Đề xuất]**, xem 8.5 mục 1). Nếu đề xuất chưa được xác nhận hoặc mỗi bên giả định bên kia làm, có thể không bên nào viết quy tắc liên bảng; lỗi do trigger cũng chưa có nơi chuyển thành lỗi API (8.6 mục 5). | PDF §6.4; `CLAUDE.md`; chú thích cuối Schema |
| C4 | TB | Nơi tính **tiến độ, gợi ý phù hợp, cảnh báo đình trệ** chưa xác định (view SQL, query JPA hay service); `database/views/` và `functions/` rỗng. Ngưỡng cảnh báo "cấu hình được, tham khảo 14 ngày" nhưng chưa có thuộc tính nào trong `application.yml`. | PDF FR05, FR10, FR11; `application.yml` |
| C5 | TB | Kiểu `TIMESTAMPTZ` đã dùng ở CSDL nhưng chưa có quy ước múi giờ ở Backend/Frontend (cấu hình Jackson, hiển thị), PDF yêu cầu "thống nhất múi giờ". | Schema; PDF §1.7 |
| C6 | TB | Nơi lưu JWT ở trình duyệt (memory/localStorage/cookie), cơ chế đăng xuất (JWT là stateless) và refresh token **chưa được quyết định**. | `API_CONTRACT.md` (TODO token lifetime/refresh); `services/api.ts` (TODO) |
| C7 | Thấp | Frontend: không có script lint/test; `npm run build` chỉ gồm `tsc --noEmit` + `vite build`. | `frontend/package.json`; `CLAUDE.md` |
| C8 | Thấp | CORS chỉ cho phép **một** origin; sẽ cần chỉnh khi triển khai thật. | `application.yml` |
| C9 | Thấp | `application-dev.yml` bật `show-sql: true` và log DEBUG; cần đảm bảo không dùng profile `dev` ở môi trường chia sẻ. | `application-dev.yml` |
| C10 | Thấp | Docker Compose chỉ dựng CSDL, schema/seed phải chạy tay → dễ lệch môi trường giữa các thành viên. | `docker-compose.yml`; `CLAUDE.md` |
| C11 | Thấp | `backend/target/` tồn tại cục bộ (được `.gitignore` loại trừ) — không ảnh hưởng repo, chỉ là sản phẩm build cũ. | `.gitignore` |

### 12.4. Những điều **không thể xác minh** (ghi rõ thay vì suy đoán)

- Schema SQL, Seed có chạy được trên PostgreSQL 16 hay không (không được phép chạy).
- `mvn -B verify` và `npm run build` có thành công hay không (không được cài package/chạy build).
- Đối chiếu tên gọi trong nhóm với 5 họ tên trong PDF: PDF không chứa tên gọi nên không xác minh được từ PDF; chỉ Nguyệt có bằng chứng trong PDF (tên riêng trùng), Liu chỉ có bằng chứng gián tiếp ngoài PDF, ba người còn lại chưa xác nhận (xem 8.1).
- Các đề xuất chờ nhóm xác nhận (8.5a mục 1, 3, 4, 5; 8.5b mục A1–A6) và các câu hỏi mở ở 8.6.
- Quy tắc chuyển trạng thái hợp lệ cho dự án: PDF chỉ liệt kê giá trị, không có ma trận. Ma trận đề xuất 2026-11-05 dùng `draft`/`open` không tương thích enum thực tế (xem 2.3); chưa biết nhóm sẽ giữ enum hiện tại hay đổi.
- Trạng thái cuối của `application` `pending` khi dự án kết thúc; việc kết thúc `position_assignment` khi dự án kết thúc; việc `paused` có đóng vị trí hay không.
- Có tồn tại chức năng quản trị danh mục kỹ năng/lĩnh vực hay vai trò admin hay không: PDF nói nằm ngoài phạm vi phiên bản đầu; chưa rõ dữ liệu `domain`/`skill` thật sẽ được nạp bằng cách nào ngoài seed.
- Ngưỡng cảnh báo đình trệ cuối cùng (PDF: "chưa cố định ở 14 ngày").
- Mục tiêu triển khai (hosting) và môi trường chạy demo.
- Nội dung các nhánh remote (`develop`, `feature/database-schema`) so với `main` hiện tại — chỉ thấy hai Merge PR #1, #2 trong lịch sử, không đọc diff chi tiết.

---

## Phụ lục A — Bản đồ tài liệu gốc

| File | Vai trò | Ghi chú |
|------|---------|---------|
| `README.md` | Tổng quan, cách chạy | Ghi rõ repo là skeleton |
| `CLAUDE.md` | Hướng dẫn cho Claude Code | Chưa commit |
| `CONTRIBUTING.md` | Nhánh, commit, PR, review | — |
| `docs/README.md` | Mô tả cấu trúc `docs/` | — |
| `docs/TEAM_WORKFLOW.md` | Phân công 5 thành viên, luồng phối hợp | Còn 2 TODO chờ họp nhóm |
| `docs/reports/bài phân tích và thiết kế CSDL.pdf` | Báo cáo Requirements → ERD → chuẩn hóa → 16 bảng | Nguồn nghiệp vụ chính; chưa commit |
| `docs/database/ERD/ERD.png` | ERD Chen (Hình 1 trong PDF) | Chưa commit |
| `docs/api/API_CONTRACT.md` | Draft hợp đồng API | Toàn `TODO` |
| `database/schema/001_create_tables.sql` | Schema 16 bảng | Nguồn sự thật cho Entity |
| `database/seeds/002_sample_data.sql` | Dữ liệu mẫu | Dữ liệu giả |
| `backend/`, `frontend/`, `deployment/`, `postman/` | Khung mã nguồn | Chỉ skeleton |
| `.github/workflows/ci.yml`, `.github/*template*` | CI, mẫu issue/PR | — |

## Phụ lục B — Gợi ý cập nhật tài liệu này

Cập nhật `docs/PROJECT_CONTEXT.md` mỗi khi: hoàn tất một nhóm chức năng (đổi nhãn ở mục 9), API contract được chốt (mục 7), thay đổi schema/migration (mục 5), hoặc nhóm trả lời các điểm ở mục 12.4.
