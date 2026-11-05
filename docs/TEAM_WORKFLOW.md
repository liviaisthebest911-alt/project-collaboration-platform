# Quy trình làm việc nhóm (Team Workflow)

Nhóm gồm 5 thành viên, làm việc trong một repository duy nhất (monorepo). Tài liệu này mô tả ai chịu trách nhiệm phần nào, các module kết nối với nhau ra sao và quy trình Git của nhóm.

> **Nguồn của phân công:** phân công chính thức do nhóm cung cấp (2026-11-05), được bổ sung bằng các quyết định và đề xuất ở các lượt cập nhật tiếp theo (2026-11-05). Các đề xuất về ma trận trạng thái, đóng tuyển dụng, contract tích hợp, exception, API tiến độ và chia thư mục frontend vẫn **chờ nhóm xác nhận**. Tên trong ngoặc (Mỡ, GL, Liu, Nguyệt, Miu) là tên gọi dùng trong nhóm.

### Cách đọc các nhãn

| Nhãn | Ý nghĩa |
|------|---------|
| **[Đã quyết định]** | Đã được chốt, áp dụng ngay. |
| **[Đề xuất]** | Đã được đưa ra, **chờ cả nhóm xác nhận** trước khi coi là chính thức. |
| **[Chưa xác nhận]** | Chưa có bằng chứng đủ rõ. |

Nội dung không gắn nhãn là phần phân công chính thức đã cung cấp trước đó (coi là đã quyết định).

## 1. Phân công chính thức

| # | Thành viên | Vai trò | Mảng phụ trách chính |
|---|------------|---------|----------------------|
| 1 | Mỡ | Database Developer kiêm Business Analyst | Nghiệp vụ, requirements, ERD, schema, trigger, constraints, functions/stored procedures, indexes, views, truy vấn báo cáo, script thay đổi CSDL, data dictionary, backup/restore |
| 2 | GL | Backend Developer – tài khoản và tuyển dụng | Authentication, Users, Profiles, Skills, Projects (entity `Project`), Positions, Applications, tìm kiếm/lọc/gợi ý, kiểm tra quyền owner, quy trình duyệt đơn |
| 3 | Liu | Backend Developer – cộng tác và quản lý dự án | Thành viên, đảm nhiệm vị trí, rời dự án, công việc, trạng thái và lịch sử dự án, tiến độ, `last_activity_at`, bàn giao owner |
| 4 | Nguyệt | Frontend Developer kiêm UI/UX | Luồng màn hình, components dùng chung, Auth Context, Axios, đăng ký/đăng nhập, hồ sơ, kỹ năng, khám phá dự án, ứng tuyển |
| 5 | Miu | Frontend Developer kiêm Deployment | Tạo/chỉnh sửa/quản lý dự án, vị trí, ứng viên, thành viên, công việc, tiến độ, lịch sử, bàn giao; Docker, CI/CD, triển khai demo |

### 1.1. Member 1 – Mỡ: Database Developer kiêm Business Analyst

**Phạm vi công việc**
- Phân tích nghiệp vụ, requirements và ERD.
- Thiết kế bảng, kiểu dữ liệu, khóa, ràng buộc và chỉ mục.
- Viết SQL tạo database, dữ liệu mẫu, views và truy vấn báo cáo.
- Quản lý script thay đổi cấu trúc database (`database/migrations/`).
- Chuẩn bị data dictionary, kiểm thử, backup và restore.
- Phối hợp Member 2 và 3 để chốt cấu trúc dữ liệu; hỗ trợ kiểm tra tính nhất quán database.
- **[Đề xuất]** Trực tiếp quản lý và triển khai: database triggers, constraints, SQL functions và stored procedures, indexes và các ràng buộc liên bảng. Member 2 và 3 xác định quy tắc nghiệp vụ tương ứng và phối hợp với Member 1 (xem 2.4).
- **[Đề xuất]** Hỗ trợ ràng buộc và kiểm thử CSDL cho việc đóng tuyển dụng khi dự án kết thúc (xem 2.9).
- **[Đề xuất]** Định nghĩa danh mục mã lỗi ổn định cho trigger/function để backend ánh xạ thành lỗi API (xem 2.11).

**Đầu ra** (suy ra từ phạm vi, chưa được nhóm liệt kê riêng)
- Tài liệu requirements và ERD (`docs/requirements/`, `docs/database/`).
- Script SQL: `database/schema/`, `database/seeds/`, `database/views/`, `database/queries/`, `database/migrations/`, và (nếu đề xuất được xác nhận) `database/triggers/`, `database/functions/`.
- Data dictionary (`docs/database/data-dictionary/`).
- Quy trình và kết quả kiểm thử, backup/restore CSDL.
- Báo cáo phần của mình.

**Mảng thư mục:** `docs/requirements`, `docs/database`, `database/`.

### 1.2. Member 2 – GL: Backend Developer phụ trách tài khoản và tuyển dụng

**Phạm vi công việc**
- Authentication, Users, Profiles.
- Skills API và danh mục.
- Projects, Positions, Applications.
- Tìm kiếm, lọc, phân trang và gợi ý vị trí.
- Gửi, rút, xem và xét duyệt đơn ứng tuyển.
- Kiểm tra quyền owner.
- Giao dịch tạo dự án, duyệt đơn và thêm thành viên.
- Kiểm thử API và tình huống duyệt đồng thời.
- **[Đã quyết định]** Sở hữu entity `Project`, tiếp tục nằm trong package `project`; phụ trách thông tin cơ bản của dự án.
- **[Đề xuất]** Sở hữu quy trình duyệt đơn ứng tuyển; khi duyệt, dùng cơ chế tích hợp đã thống nhất với Member 3 để tạo thành viên và phân công vị trí (xem 2.3). Xác định quy tắc nghiệp vụ tuyển dụng và duyệt đơn, phối hợp Member 1.
- **[Đề xuất]** Sở hữu logic đóng `Position` và xử lý `Application` `pending` khi dự án `completed`/`cancelled`, cung cấp qua contract công khai cho Member 3 (xem 2.9, 2.10).
- **[Đề xuất]** Cung cấp dữ liệu vị trí qua contract/query công khai cho API tiến độ của Member 3 (xem 2.5).
- **[Đề xuất]** Sở hữu cấu trúc dùng chung ban đầu: `common/exception`, `common/response`, `GlobalExceptionHandler`, quy chuẩn error code và response lỗi (xem 2.11).

**Đầu ra** (suy ra từ phạm vi)
- API và logic nghiệp vụ của các nhóm trên, được mô tả trong `docs/api/API_CONTRACT.md` trước khi cài đặt.
- Cấu hình bảo mật (Spring Security, JWT, CORS) dùng chung cho toàn backend.
- Các giao dịch tạo dự án, duyệt đơn.
- Bộ kiểm thử API, gồm kiểm thử duyệt đơn đồng thời.
- Báo cáo phần của mình.

**Mảng thư mục:** `backend/.../auth`, `user`, `skill`, `project`, `position`, `application`, `security`, `config`.

### 1.3. Member 3 – Liu: Backend Developer phụ trách cộng tác và quản lý dự án

**Phạm vi công việc**
- API quản lý thành viên, đảm nhiệm/thôi vị trí và rời dự án.
- API quản lý công việc, giao việc và cập nhật trạng thái.
- Kiểm tra thành viên đang hoạt động và thuộc đúng dự án.
- Xử lý phân công khi thành viên rời dự án.
- Cập nhật `last_activity_at` và dữ liệu cảnh báo đình trệ.
- Quản lý trạng thái dự án và ghi lịch sử trạng thái.
- API gửi, hủy, chấp nhận và từ chối bàn giao.
- Giao dịch chuyển owner, bảo đảm đúng một owner hoạt động.
- Kết nối views và truy vấn do Member 1 cung cấp.
- Kiểm thử cộng tác, rời dự án, bàn giao và rollback.
- **[Đã quyết định]** Logic chuyển trạng thái dự án; entity và logic ghi nhận lịch sử trạng thái.
- **[Đề xuất]** Entity, Repository và logic quản lý vòng đời `ProjectMember` và `PositionAssignment`.
- **[Đề xuất]** API tiến độ dự án (dữ liệu tiến độ phụ thuộc Task, Member, Assignment và trạng thái công việc), kèm thống kê sức chứa vị trí `capacity`, `filled`, `available` (xem 2.5).
- **[Đề xuất]** Xác định quy tắc nghiệp vụ về thành viên, rời dự án và bàn giao, phối hợp Member 1 để có trigger/constraint tương ứng.
- **[Đề xuất]** Chuyển trạng thái dự án theo ma trận mà nhóm sẽ chọn (xem 2.2.1); khi dự án kết thúc, gọi contract của Member 2 để đóng tuyển dụng trong cùng giao dịch (xem 2.9).
- **[Đề xuất]** Khai báo exception nghiệp vụ của module mình và phối hợp Member 2 để ánh xạ lỗi (xem 2.11).

**Đầu ra** (suy ra từ phạm vi)
- API và logic nghiệp vụ của các nhóm trên, được mô tả trong `docs/api/API_CONTRACT.md` trước khi cài đặt.
- Giao dịch rời dự án và chuyển owner.
- Bộ kiểm thử cộng tác, rời dự án, bàn giao và rollback.
- Báo cáo phần của mình.

**Mảng thư mục:** `backend/.../member`, `task`, `handover`. Entity `Project` thuộc Member 2 và không được sửa nếu chưa thống nhất (xem 2.2). **[Đề xuất]** Module lịch sử trạng thái có thể đặt trong package `history` nếu phù hợp kiến trúc; package này **chưa tồn tại** trong khung hiện tại và chưa được tạo.

**Nhánh làm việc [Đã quyết định]:** xem mục 4.

### 1.4. Member 4 – Nguyệt: Frontend Developer kiêm UI/UX

**Phạm vi công việc**
- Thiết kế luồng màn hình và giao diện chung.
- Xây dựng components dùng chung.
- Giao diện đăng ký, đăng nhập, hồ sơ và kỹ năng.
- Danh sách, tìm kiếm, lọc và chi tiết dự án.
- Gợi ý vị trí, gửi đơn, xem đơn và rút đơn.
- Kết nối API thật và xử lý trạng thái giao diện.
- Kiểm thử luồng người dùng tìm dự án và ứng tuyển.
- **[Đã quyết định]** Giữ trách nhiệm xây dựng Auth Context, cấu hình Axios instance và interceptor, cung cấp cơ chế xác thực dùng chung cho Frontend. Member 5 sử dụng lại các thành phần này.

**Đầu ra** (suy ra từ phạm vi)
- Thiết kế luồng màn hình và bộ components dùng chung (`frontend/src/components/`).
- Auth Context, Axios instance và interceptor JWT (`frontend/src/contexts/`, `frontend/src/services/api.ts`).
- Các trang: đăng ký, đăng nhập, hồ sơ/kỹ năng, danh sách/tìm kiếm/chi tiết dự án, gửi và rút đơn ứng tuyển.
- Báo cáo phần của mình.

**Mảng thư mục:** `frontend/src/pages/auth`, `profile`, `projects` (khám phá; **[Đề xuất]** chuyển thành `projects/discovery/`, xem 2.6), `applications` (ứng tuyển); chia sẻ `components/`, `services/`, `routes/`, `contexts/`.

### 1.5. Member 5 – Miu: Frontend Developer kiêm Deployment

**Phạm vi công việc**
- Giao diện dự án đã tạo/tham gia.
- Quản lý dự án, vị trí và ứng viên.
- Quản lý thành viên và vị trí đảm nhiệm.
- Giao diện công việc, phân công và tiến độ.
- Hiển thị cảnh báo, lịch sử và bàn giao.
- Kết nối API Member 2 và 3.
- Sử dụng components chung do Member 4 xây dựng; dùng lại Auth Context và Axios của Member 4.
- Docker, cấu hình môi trường, CI/CD và triển khai demo.
- Viết hướng dẫn khởi động và kiểm thử sau triển khai.
- **[Đề xuất]** Phụ trách giao diện tạo dự án, chỉnh sửa dự án, quản lý vị trí và ứng viên. **[Đề xuất]** Chia `pages/projects` thành `discovery/` (Member 4) và `management/` (Member 5), không cùng sửa một page/component khi chưa thống nhất (xem 2.6).

**Đầu ra** (suy ra từ phạm vi)
- Các trang tạo/chỉnh sửa/quản lý dự án, vị trí, ứng viên, thành viên, công việc, tiến độ, cảnh báo, lịch sử, bàn giao.
- Docker, cấu hình môi trường, CI/CD, bản triển khai demo.
- Hướng dẫn khởi động và kết quả kiểm thử sau triển khai.
- Báo cáo phần của mình.

**Mảng thư mục:** `frontend/src/pages/projects` (quản lý; **[Đề xuất]** `projects/management/`), `members`, `tasks` (vị trí của hai thư mục này so với `management/` chưa chốt, xem 2.6), `deployment/`, `.github/workflows`, `docker-compose.yml`.

### 1.6. Kỹ năng và lịch sử dự án

| Nội dung | Backend | Frontend |
|----------|---------|----------|
| Kỹ năng (Skills API, danh mục; kỹ năng trong hồ sơ) | Member 2 | Member 4 |
| Lịch sử dự án (lịch sử trạng thái) | Member 3 | Member 5 |

## 2. Quy tắc phối hợp

### 2.1. Quy tắc chung

- Member 1 chốt cấu trúc dữ liệu cùng Member 2 và 3, **không tự quyết định thay nghiệp vụ của backend**. Thành viên backend yêu cầu Member 1 thay đổi schema, không tự sửa file SQL.
- Member 2 và 3 thống nhất API với Member 4 và 5 **trước khi triển khai**. Hợp đồng nằm ở `docs/api/API_CONTRACT.md`.
- Frontend có thể dùng dữ liệu mẫu trong thời gian chờ API.
- **Giao dịch duyệt đơn thuộc Member 2.** **Giao dịch rời dự án và bàn giao owner thuộc Member 3.**
- Member 1 hỗ trợ kiểm tra tính nhất quán database.
- Mỗi thành viên tự kiểm thử và viết báo cáo phần mình. Cả nhóm phối hợp tích hợp và sửa lỗi.
- Member 5 phụ trách triển khai, **không mặc nhiên chịu trách nhiệm sửa mọi lỗi** của các thành viên khác.

### 2.2. Project, trạng thái và lịch sử dự án

- **[Đã quyết định]** Entity `Project` thuộc Member 2, nằm trong package `project`.
- **[Đã quyết định]** Logic chuyển trạng thái dự án, entity và logic ghi nhận lịch sử trạng thái thuộc Member 3.
- **[Đã quyết định]** Member 2 và Member 3 phải thống nhất các trường, enum và phương thức tương tác với `Project`.
- **[Đã quyết định]** Không tạo entity `Project` trùng lặp; không tự ý sửa entity thuộc Member khác.
- Lưu ý từ nghiệp vụ (PDF §1.6, tr. 5): dự án sang `completed`/`cancelled` kéo theo đóng các vị trí đang tuyển và không chấp nhận đơn `pending` còn lại. Phần này được đề xuất xử lý ở 2.9.

#### 2.2.1. Ma trận chuyển trạng thái dự án — **[Đề xuất]**, chưa áp dụng

Ma trận được đề xuất (nguyên văn):

- `draft` → `open`, `cancelled`
- `open` → `paused`, `completed`, `cancelled`
- `paused` → `open`, `completed`, `cancelled`
- `completed`, `cancelled` là trạng thái kết thúc.

**PDF chưa quy định chuyển trạng thái nào hợp lệ** (PDF §1.6 chỉ liệt kê giá trị). Vì vậy đây là đề xuất cần nhóm xác nhận.

**Đối chiếu với enum thực tế:**

| Nguồn | Giá trị trạng thái của dự án |
|-------|------------------------------|
| PDF §1.6, tr. 5 và §5.1.6, tr. 17 | `planning`, `active`, `paused`, `completed`, `cancelled` |
| `database/schema/001_create_tables.sql` (`ck_project_status`, `ck_history_old_status`, `ck_history_new_status`) | `planning`, `active`, `paused`, `completed`, `cancelled`; mặc định `planning` |
| `database/seeds/002_sample_data.sql` | Chỉ dùng `planning`, `active`, `paused` (chuyển `planning`→`active`, `active`→`paused`) |
| Source code Java | Chưa có enum hay entity (các package chỉ có `.gitkeep`) |
| Ma trận đề xuất | `draft`, `open`, `paused`, `completed`, `cancelled` |

**Kết luận đối chiếu:**
- `draft` và `open` **không tồn tại** trong PDF, schema, seed hay source code. Ma trận **không tương thích về tên** với enum hiện tại và **không được áp dụng**. Không sửa code, schema hay migration.
- `open` còn là giá trị trạng thái của **vị trí** (`ck_position_status`: `open`/`closed`). Dùng cùng tên cho dự án dễ gây nhầm lẫn.
- Nếu nhóm muốn đổi tên enum sang `draft`/`open`, phải đi qua Member 1 (schema và migration) và cập nhật nghiệp vụ trong PDF. Việc đó nằm ngoài phạm vi tài liệu này.

**Đối chiếu tên (suy luận của người phân tích, chưa được nhóm xác nhận):** nếu giữ enum hiện tại và coi `draft` ≈ `planning`, `open` ≈ `active`, ma trận tương ứng là:

- `planning` → `active`, `cancelled`
- `active` → `paused`, `completed`, `cancelled`
- `paused` → `active`, `completed`, `cancelled`
- `completed`, `cancelled` là trạng thái kết thúc.

Bản đối chiếu này khớp với dữ liệu mẫu và với chính sách PDF "chỉ dự án `planning` hoặc `active` được nhận và duyệt đơn", nhưng vẫn **chưa phải quyết định**.

**Lưu ý khi thực thi (nếu nhóm chấp nhận một ma trận):**
- Schema chỉ có `CHECK (old_status <> new_status)` trong `project_status_history`; **không có ràng buộc chuyển trạng thái hợp lệ**. Việc kiểm tra do service của Member 3 hoặc trigger của Member 1 (đề xuất, 2.4) đảm nhiệm.
- Cập nhật trạng thái và ghi `project_status_history` phải nằm trong cùng giao dịch (PDF §6.4 mục 6, tr. 22; FR12).
- Chuyển sang cùng trạng thái phải bị chặn ở tầng nghiệp vụ, trước khi chạm ràng buộc `old_status <> new_status` của CSDL.
- `project_status_history.changed_by` là `NOT NULL`. PDF (§5.1.15, tr. 19) nói thay đổi tự động dùng "tài khoản hệ thống", nhưng schema và seed **chưa có tài khoản hệ thống**. Cần quyết định nếu có chuyển trạng thái tự động.

### 2.3. `ProjectMember`, `PositionAssignment` và duyệt đơn — **[Đề xuất]**

- Member 3 sở hữu Entity, Repository và logic vòng đời `ProjectMember` và `PositionAssignment`.
- Member 2 sở hữu quy trình duyệt đơn ứng tuyển. Khi duyệt (và khi tạo dự án để thêm owner), Member 2 dùng **contract tích hợp công khai do Member 3 cung cấp** (xem 2.10) để tạo thành viên và phân công vị trí; **không** truy cập repository nội bộ hay ghi trực tiếp vào hai bảng này.
- Hai Member thống nhất **transaction boundary** (phạm vi giao dịch) để không tạo dữ liệu không nhất quán (xem 2.10).
- Cơ sở nghiệp vụ: PDF FR03 (tạo dự án thì thêm người tạo làm owner), FR07 (chấp nhận đơn thì thêm hoặc khôi phục thành viên và ghi vị trí đảm nhiệm, tất cả trong cùng một giao dịch).

### 2.4. Trigger, constraint, function, index — **[Đề xuất]**

- Member 1 trực tiếp quản lý và triển khai: database triggers, constraints, SQL functions và stored procedures, indexes và các ràng buộc liên bảng.
- Member 2 và 3 xác định quy tắc nghiệp vụ tương ứng và phối hợp với Member 1:
  - Quy tắc tuyển dụng và duyệt đơn: Member 2 phối hợp Member 1.
  - Quy tắc thành viên, rời dự án và bàn giao: Member 3 phối hợp Member 1.
- **Không thành viên nào tự ý sửa script database của thành viên khác.**

### 2.5. API tiến độ và sức chứa vị trí — **[Đề xuất]**

- Member 3 sở hữu API tiến độ dự án; Member 2 tiếp tục phụ trách thông tin cơ bản của `Project`.
- API tiến độ bổ sung thống kê sức chứa vị trí: `capacity`, `filled`, `available`.
- Member 2 cung cấp dữ liệu vị trí (ví dụ mã, tên, `slots`, trạng thái) qua contract hoặc query công khai (2.10). Member 3 tổng hợp vào API tiến độ.

**Định nghĩa đề xuất, đối chiếu với PDF §2.5 (tr. 8) và schema:**

| Trường đề xuất | Ánh xạ | Cách xác định |
|----------------|--------|---------------|
| `capacity` | `position.slots` | Tổng số người cần cho vị trí (số nguyên dương, BR5) |
| `filled` | Số người đang đảm nhiệm hợp lệ | Số dòng `position_assignment` của vị trí có `ended_at IS NULL` **và** thành viên tương ứng có `left_at IS NULL` |
| `available` | `remaining_slots` trong PDF | `capacity - filled` (BR6 bảo đảm `filled` không vượt `capacity`) |

**Lưu ý:**
- Tên `capacity/filled/available` **khác** tên trong PDF/schema (`slots`, `remaining_slots`). Cần nhóm xác nhận tên dùng trong API.
- `filled` lấy từ `position_assignment`, bảng được đề xuất thuộc Member 3 (2.3). Phần cần Member 2 chỉ là dữ liệu vị trí.
- PDF FR10 yêu cầu phân biệt vị trí "chưa đủ người" (`available > 0`) với vị trí "đang mở tuyển" (`status = 'open'`). Vị trí `closed` mà `available > 0` là "chưa đủ người nhưng không còn tuyển".
- PDF FR10: người kiêm nhiều vị trí chỉ tính là **một** thành viên. Số thành viên của dự án phải đếm theo người, khác với tổng `filled` của các vị trí.
- Phụ thuộc ngược: FR05 (Member 2) lọc "vị trí đang mở và còn chỗ" cũng cần `available`, tức là Member 2 cần số người đang đảm nhiệm từ dữ liệu của Member 3. Cần một contract/query theo chiều ngược lại, hoặc một view dùng chung do Member 1 cung cấp. Chưa quyết định.
- **Hợp đồng API chưa được sửa.** Hiện `GET /api/projects/{projectId}/progress` nằm trong nhóm Projects và body còn `TODO`. Cần PR nhỏ tách hai phạm vi (thông tin cơ bản: Member 2; tiến độ: Member 3) và định nghĩa trường, có review của một Backend và một Frontend.

### 2.6. Chia việc Frontend và thư mục `pages/projects`

- **[Đề xuất]** Chia `pages/projects` thành hai thư mục con (cả hai **chưa tồn tại**, chưa tạo):

```text
frontend/src/pages/projects/
├── discovery/     # Member 4: danh sách, tìm kiếm, chi tiết dự án, gửi và rút đơn ứng tuyển
└── management/    # Member 5: dự án của tôi, tạo/sửa dự án, quản lý vị trí, ứng viên,
                   #           thành viên, task, tiến độ và bàn giao
```

- **[Đề xuất]** Hai thành viên không cùng sửa một page/component nếu chưa thống nhất.
- **[Đã quyết định]** Member 4 giữ Auth Context, Axios instance và interceptor; Member 5 dùng lại.

**Điểm cần làm rõ (xung đột với khung hiện có):**
- Khung frontend đã có sẵn thư mục `pages/members`, `pages/tasks` (bản phân công cũ gán cho Member 5) và `pages/applications`. Đề xuất đặt thành viên và task trong `management/` trùng với hai thư mục này. Cần chọn: đặt trong `management/` hay giữ `members/`, `tasks/`.
- Xem đơn ứng tuyển của tôi (Member 4) đặt ở `pages/applications` hay `discovery/`?
- `App.tsx`, `routes/` và `components/` là các điểm dùng chung dễ xung đột merge. Cần thống nhất cách mỗi người đăng ký route của mình và cách Member 5 đóng góp component vào `components/` do Member 4 sở hữu.

### 2.7. Cách các phần kết nối (giữ từ bản cũ)

```text
Member 1 (database)  ──schema──▶  Member 2 + Member 3 (backend)  ──API contract──▶  Member 4 + Member 5 (frontend)
        ▲                                                                                      │
        └────────────── requirements / câu hỏi ◀───────────────────────────────────────────────┘
Member 5 (deployment) hỗ trợ môi trường: Docker, CI, cấu hình.
```

- **Member 1 → Member 2 và 3:** schema, ràng buộc và dữ liệu mẫu là nguồn sự thật cho JPA entity.
- **Member 2 ↔ Member 3:** hai bên phụ thuộc lẫn nhau. Module của Member 3 cần entity `user`, `project`, `position` và xác thực của Member 2. Ngược lại, tạo dự án và duyệt đơn của Member 2 cần tạo thành viên/phân công do Member 3 quản lý (xem 2.3). **[Đề xuất]** Hai bên tích hợp qua contract công khai, không dùng chung entity hay repository nội bộ (xem 2.10).
- **Backend → Frontend:** hợp đồng `docs/api/API_CONTRACT.md` được thống nhất trước. Frontend có thể xây dựng theo hợp đồng trước khi backend xong.
- **Member 4 ↔ Member 5:** dùng chung `components/`, `services/`, `routes/`, `contexts/`. Member 4 tạo Auth Context và Axios; Member 5 dùng lại. Luồng ứng tuyển nối hai bên: Member 4 làm "ứng tuyển", Member 5 làm "xem xét ứng viên".
- **Member 5 → mọi người:** giữ `docker-compose.yml`, CI và script triển khai hoạt động; hỗ trợ vấn đề cài đặt môi trường (trong giới hạn nêu ở 2.1).

### 2.8. Bảng ranh giới Member 2 và Member 3

| Luồng nghiệp vụ | Chủ sở hữu | Trạng thái | Ghi chú |
|-----------------|------------|------------|---------|
| Entity `Project`, thông tin cơ bản dự án | Member 2 | Đã quyết định | Package `project` |
| Tạo dự án (kèm giao dịch) | Member 2 | Đã quyết định | Cần thêm owner qua cơ chế của Member 3 (2.3) |
| Duyệt đơn ứng tuyển | Member 2 | Đề xuất (quy trình), đã quyết định (giao dịch) | Tạo thành viên/phân công qua Member 3 |
| Kiểm tra quyền owner | Member 2 | Đã quyết định | Member 3 cần dùng lại, không viết lặp |
| Tìm kiếm, lọc, phân trang, gợi ý vị trí | Member 2 | Đã quyết định | |
| `ProjectMember`, `PositionAssignment` (entity, repository, vòng đời) | Member 3 | Đề xuất | |
| Rời dự án, xử lý phân công khi rời | Member 3 | Đã quyết định | Giao dịch thuộc Member 3 |
| Công việc: tạo, giao, cập nhật trạng thái | Member 3 | Đã quyết định | |
| Chuyển trạng thái dự án; entity và logic lịch sử | Member 3 | Đã quyết định | Thống nhất trường/enum/phương thức của `Project` với Member 2. Ma trận chuyển trạng thái: đề xuất, chưa áp dụng (2.2.1) |
| `last_activity_at`, dữ liệu cảnh báo đình trệ | Member 3 | Đã quyết định | |
| API tiến độ dự án, gồm `capacity`, `filled`, `available` | Member 3 | Đề xuất | Cần cập nhật hợp đồng API (2.5) |
| Bàn giao: gửi, hủy, chấp nhận, từ chối; chuyển owner | Member 3 | Đã quyết định | Giao dịch thuộc Member 3 |
| Trigger, constraint, function, index, ràng buộc liên bảng | Member 1 | Đề xuất | Member 2 và 3 cung cấp quy tắc nghiệp vụ |
| Đóng `Position` và xử lý `Application` `pending` khi dự án kết thúc | Member 2 | Đề xuất | Member 3 gọi qua contract; cùng một giao dịch (2.9) |
| Contract tích hợp: tạo `ProjectMember`/`PositionAssignment` | Member 3 cung cấp, Member 2 dùng | Đề xuất | 2.10 |
| `common/exception`, `common/response`, `GlobalExceptionHandler`, error code | Member 2 | Đề xuất | Member 3 khai báo exception module mình (2.11) |
| Danh mục mã lỗi trigger/function | Member 1 | Đề xuất | 2.11 |

### 2.9. Đóng tuyển dụng khi dự án kết thúc — **[Đề xuất]**

**Nghiệp vụ trong PDF (§1.6, tr. 5):** khi dự án hoàn thành/hủy thì đóng các vị trí đang tuyển; các đơn còn chờ không được chấp nhận khi dự án đã kết thúc; vị trí `closed` bắt buộc có `closed_at` (`ck_position_closed_at`).

**Phân công đề xuất:**

| Việc | Chủ sở hữu |
|------|------------|
| Logic chuyển trạng thái `Project` sang `completed`/`cancelled`, ghi `project_status_history` | Member 3 |
| Logic đóng `Position` và xử lý `Application` `pending` | Member 2 |
| Hỗ trợ ràng buộc và kiểm thử CSDL | Member 1 |

Member 3 gọi logic của Member 2 qua contract công khai (2.10); không truy cập trực tiếp `position`, `application` của Member 2.

**Transaction:** các thay đổi bắt buộc nằm trong **cùng một giao dịch** để không còn dữ liệu dở dang: (1) cập nhật trạng thái `Project`; (2) ghi `project_status_history`; (3) đóng các `Position` đang `open` (đặt `closed` và `closed_at`); (4) xử lý các `Application` `pending`. Một bước lỗi thì rollback toàn bộ. Cơ sở: PDF §6.4 mục 6 (tr. 22), §1.7 (tr. 5).

**Trạng thái cuối của `Application` `pending` — chưa thống nhất.** PDF chỉ nói đơn không được chấp nhận, **không quy định giá trị cuối**. Các lựa chọn, đối chiếu với `ck_application_decision` trong schema:

| Lựa chọn | Tương thích schema | Vấn đề |
|----------|-------------------|--------|
| Giữ `pending` | Có | Đơn treo vĩnh viễn; mọi nơi đọc đơn phải tự lọc theo trạng thái dự án; `uq_application_pending` vẫn giữ chỗ |
| `rejected` | Có, nhưng cần `processed_by` (`NOT NULL`) và `decided_at` | Cần người xử lý: owner thực hiện chuyển trạng thái hay tài khoản hệ thống (schema chưa có); dễ nhầm với từ chối thủ công |
| `withdrawn` | Có (`processed_by` và `decided_at` phải trống) | Sai nghĩa: `withdrawn` là người nộp rút đơn; PDF §6.3 ghi chưa lưu riêng thời điểm rút |
| Giá trị mới (ví dụ `cancelled`) | **Không**: `ck_application_status` chỉ cho 4 giá trị, PDF cũng chỉ liệt kê 4 | Phải đổi schema qua Member 1 (migration) và cập nhật nghiệp vụ |

Tài liệu này không chọn thay nhóm. Tên giá trị mới ở dòng cuối chỉ là ví dụ minh họa.

**Câu hỏi bổ sung cho nhóm:**
- Khi dự án `completed`/`cancelled`, các `position_assignment` đang hiệu lực có bị kết thúc không? PDF chỉ nêu việc kết thúc đảm nhiệm khi thành viên rời dự án (FR08).
- Chuyển sang `paused` có đóng vị trí không? PDF chỉ nêu `completed`/`cancelled`.
- Duyệt đơn (Member 2) có thể chạy đồng thời với chuyển dự án sang `completed`/`cancelled` (Member 3). Cần cơ chế khóa dùng chung (ví dụ khóa dòng `project`) để không duyệt được đơn vào dự án vừa kết thúc.
- Ràng buộc nào Member 1 nên bổ sung (ví dụ chặn chuyển một đơn thành `accepted` khi dự án đã kết thúc, theo BR11 và chính sách PDF) và kịch bản kiểm thử CSDL tương ứng.

### 2.10. Contract tích hợp giữa các module — **[Đề xuất]**

**Nguyên tắc đề xuất:**
- Dùng interface/contract công khai, tách khỏi entity và repository nội bộ của mỗi module.
- **Không truy cập repository nội bộ** của module khác.
- **Không tạo phụ thuộc trực tiếp giữa các entity.** Tham chiếu sang module khác bằng khóa `id`, không dùng quan hệ JPA tới entity của module đó. Khóa ngoại vẫn tồn tại ở CSDL theo schema. Hệ quả: mất khả năng điều hướng quan hệ trong JPA; các truy vấn nhiều bảng cần views/truy vấn của Member 1 hoặc query riêng.
- Trao đổi qua DTO hoặc giá trị đơn giản, không trả entity ra ngoài module. Việc này cũng phù hợp với cấu hình `open-in-view: false` (không dựa vào lazy loading ngoài giao dịch).

**Các contract cần có:**

| Contract | Bên cung cấp | Bên sử dụng | Dùng khi |
|----------|--------------|-------------|----------|
| Tạo `ProjectMember` (kể cả owner) và `PositionAssignment` | Member 3 | Member 2 | Tạo dự án (FR03), duyệt đơn (FR07) |
| Đóng tuyển dụng: đóng `Position`, xử lý `Application` `pending` | Member 2 | Member 3 | Dự án sang `completed`/`cancelled` (2.9) |
| Đọc dữ liệu `Project` (trạng thái, owner) và `Position` (`slots`, trạng thái) | Member 2 | Member 3 | Chuyển trạng thái, API tiến độ (2.5). Hai contract này tôi bổ sung vì cần thiết; chưa được nhóm nêu |
| Đếm người đang đảm nhiệm theo vị trí | Member 3 | Member 2 | Lọc vị trí còn chỗ (FR05). Cũng do tôi bổ sung |

**Vị trí package đề xuất (dựa trên kiến trúc thực tế).** `backend/README.md` quy ước mỗi package tính năng có các sub-package `controller`, `service`, `repository`, `entity`, `dto`; chưa có sub-package nào khác và chưa có mã.
- *Phương án A (khớp quy ước hiện có, không thêm sub-package):* đặt interface trong sub-package `service` của module **cung cấp** (ví dụ `com.projectcollab.member.service`) và DTO tương ứng trong `dto` của module đó. Module sử dụng chỉ import interface và DTO. Cài đặt và repository nằm nội bộ.
- *Phương án B:* thêm sub-package `api` cho từng module. Cần cập nhật quy ước trong `backend/README.md`.

Cả hai phương án **chưa được tạo**; nhóm chọn. Lưu ý: Java và Maven đơn module không ngăn truy cập chéo, và `pom.xml` không có công cụ kiểm tra kiến trúc; quy tắc dựa vào review. Thêm công cụ kiểm tra là thay đổi `pom.xml`, cần quyết định riêng.

**Cảnh báo phụ thuộc vòng ở mức package.** Dù đã tách interface, Member 2 phụ thuộc `member` (Member 3) và Member 3 phụ thuộc `project`, `position`, `application` (Member 2) sẽ tạo vòng `project` ↔ `member`. Các hướng xử lý để nhóm cân nhắc: (i) chấp nhận vòng ở mức interface, có quy tắc review; (ii) đặt các interface dùng chung ở một vị trí trung lập có chủ sở hữu rõ (hiện chưa có); (iii) dùng sự kiện nội bộ để đảo chiều phụ thuộc. Hướng (iii) là gợi ý kỹ thuật của người phân tích, không có trong tài liệu hiện có.

**Transaction boundary và rollback (đề xuất):**
- Giao dịch do module **điều phối** mở: duyệt đơn và tạo dự án do service của Member 2 mở; chuyển trạng thái dự án do service của Member 3 mở. Contract của module còn lại **tham gia giao dịch hiện có**, không mở giao dịch độc lập.
- Mọi bước cùng thành công hoặc cùng rollback. Contract không nuốt lỗi (`try/catch` không rethrow).
- Spring `@Transactional` mặc định chỉ rollback với `RuntimeException` và `Error`; exception nghiệp vụ nên là unchecked hoặc khai báo `rollbackFor`. *Đây là kiến thức kỹ thuật chung, chưa kiểm chứng vì dự án chưa có mã.*
- Kiểm thử: Member 3 kiểm thử rollback; Member 2 kiểm thử duyệt đồng thời.

### 2.11. Exception, response và lỗi từ trigger PostgreSQL — **[Đề xuất]**

**Sở hữu:**
- Member 2 sở hữu cấu trúc dùng chung ban đầu: `common/exception`, `common/response`, `GlobalExceptionHandler`, quy chuẩn error code và response lỗi. `GlobalExceptionHandler` **chưa tồn tại**, chưa được tạo.
- Member 3 khai báo exception nghiệp vụ của module mình và phối hợp Member 2 để ánh xạ.
- Trước khi cài đặt, định dạng response chung và error body phải được chốt trong hợp đồng: hiện `docs/api/API_CONTRACT.md` ghi `TODO` cho "Common response envelope" và "Common error body" (quy tắc hợp đồng đi trước).

**Quy trình chuyển lỗi trigger/ràng buộc PostgreSQL thành lỗi API (đề xuất):**
1. **Kiểm tra ở service trước.** Service kiểm tra quy tắc nghiệp vụ và trả lỗi nghiệp vụ rõ ràng; ràng buộc/trigger của CSDL là lớp phòng thủ cuối.
2. **Member 1 định nghĩa danh mục lỗi** cho trigger và function: mỗi quy tắc có mã lỗi ổn định (SQLSTATE tùy chỉnh khi `RAISE` và/hoặc tên constraint cố định). Ý nghĩa không đặt vào chuỗi thông báo. Danh mục được ghi tài liệu (vị trí gợi ý: `docs/database/` hoặc `docs/architecture/`, chưa tạo).
3. **Backend ánh xạ bằng mã, không bằng chuỗi.** `GlobalExceptionHandler` (Member 2) lấy SQLSTATE và tên constraint từ ngoại lệ gốc của driver PostgreSQL (duyệt chuỗi `cause` của ngoại lệ Spring/Hibernate), tra bảng ánh xạ để ra mã lỗi API và HTTP status (400/403/404/409... theo hợp đồng). **Không phân tích nội dung thông báo lỗi**, vì không ổn định.
4. **Lỗi chưa có trong bảng** trả về mã lỗi chung và thông điệp chung (HTTP 500). Chi tiết SQL chỉ ghi log, **không trả cho frontend**.
5. **Frontend chỉ dựa vào mã lỗi API**, không dựa vào nội dung thông báo. PDF §1.7 yêu cầu thông báo rõ lý do khi thao tác thất bại.
6. Các constraint hiện có đã có tên ổn định trong schema để làm khóa ánh xạ: `uq_users_email`, `uq_project_active_owner`, `uq_application_pending`, `uq_handover_pending`, các `ck_*`. Lớp SQLSTATE 23 của PostgreSQL gồm 23505 (unique), 23514 (check), 23503 (foreign key). *Cách lấy các giá trị này từ ngoại lệ chưa được kiểm chứng trên dự án vì chưa có mã; cần thử nghiệm khi cài đặt.*

**Phối hợp:** Member 1 (danh mục lỗi CSDL), Member 2 (handler và định dạng lỗi), Member 3 (exception nghiệp vụ module mình) cùng giữ một bảng ánh xạ lỗi CSDL → lỗi API.

## 3. Quy tắc làm việc (Working agreement)

1. Lập kế hoạch: team leader tạo mỗi task một GitHub issue và giao người thực hiện.
2. Hợp đồng trước: sửa `docs/api/API_CONTRACT.md` trong một PR nhỏ **trước khi** cài đặt endpoint.
3. Tạo branch từ `develop` theo quy tắc đặt tên trong `CONTRIBUTING.md`.
4. Commit nhỏ, push thường xuyên, mở PR vào `develop`, cần 1 review.
5. Họp tuần: ghi biên bản trong `docs/meeting-notes/` (tên file `YYYY-MM-DD.md`).
6. `develop` chỉ được merge vào `main` ở các mốc demo ổn định.

## 4. Branch

### 4.1. Branch của Member 3 — **[Đã quyết định]**

- `feature/member-management`
- `feature/member-leaving`
- `feature/project-progress`
- `feature/project-history`
- `feature/owner-handover`
- `feature/task-management` — branch **backend** task management của Member 3 (xác nhận theo yêu cầu của bạn).

Tất cả branch được tạo từ `develop` và mở PR vào `develop`. Mỗi thành viên tự thực hiện thao tác Git của mình.

**Quy tắc cho `feature/task-management`:** không gộp code frontend của Member 5 vào branch này nếu hai người phát triển độc lập. Phần giao diện công việc của Member 5 dùng branch riêng; **tên branch này chưa được xác định**.

### 4.2. Branch khởi đầu gợi ý (giữ từ bản cũ)

- `feature/database-schema` (Member 1)
- `feature/user-authentication` (Member 2 và 4)
- `feature/project-management` (Member 2 và 5)
- `feature/application-management` (Member 2 và 4)
- `feature/task-management` (bản cũ ghi Member 3 và 5; nay được xác định là branch backend của Member 3, xem 4.1)

> Ba branch còn lại trong danh sách cũ vẫn ghi hai thành viên dùng chung (một backend, một frontend). Việc tách chúng theo cùng nguyên tắc như `feature/task-management` **chưa được quyết định**.

Các quy định Git, commit và Pull Request giữ nguyên nội dung cũ (chi tiết trong `CONTRIBUTING.md`).

## 5. Đối chiếu tên gọi với họ tên trong báo cáo PDF

Đã đối chiếu lại trang bìa PDF `docs/reports/bài phân tích và thiết kế CSDL.pdf` ngày 2026-11-05. PDF liệt kê 5 thành viên kèm mã số sinh viên nhưng **không chứa tên gọi trong nhóm**, nên không thể xác minh từng ánh xạ chỉ bằng PDF. Kết quả không đổi so với lần trước.

| Member | Tên gọi | Họ tên do nhóm cung cấp | MSSV trong PDF | Bằng chứng | Trạng thái |
|--------|---------|--------------------------|----------------|------------|------------|
| 1 | Mỡ | Hoàng Thảo Linh | 25000260 | Họ tên có trong PDF; không có dữ kiện nào nối với tên gọi "Mỡ" | **[Chưa xác nhận]** |
| 2 | GL | Thái Thị Gia Linh | 25000263 | Họ tên có trong PDF; "GL" có thể là viết tắt của "Gia Linh" nhưng đây chỉ là suy đoán (còn nhiều tên có "Linh") | **[Chưa xác nhận]** |
| 3 | Liu | Trần Lê Thảo Linh | 25000265 | Họ tên có trong PDF; cấu hình Git cục bộ có `user.name` là `Liu Tran Le`. Bằng chứng này nằm ngoài PDF | **[Chưa xác nhận]** (có bằng chứng gián tiếp) |
| 4 | Nguyệt | Vũ Thị Ánh Nguyệt | 25000280 | Tên gọi trùng tên riêng "Nguyệt" trong PDF; chỉ một thành viên trong PDF có tên này | Có bằng chứng trong PDF (tên riêng trùng) |
| 5 | Miu | Trần Đậu Nhật Linh | 25000264 | Họ tên có trong PDF; không có dữ kiện nào nối với tên gọi "Miu" | **[Chưa xác nhận]** |

Cần nhóm xác nhận các dòng chưa xác nhận.

## 6. Các quyết định và đề xuất (tóm tắt)

### 6.1. Từ các lượt trước

| # | Nội dung | Trạng thái |
|---|----------|------------|
| 1 | Member 1 quản lý trigger, constraint, function/stored procedure, index, ràng buộc liên bảng; Member 2, 3 cung cấp quy tắc nghiệp vụ | Đề xuất |
| 2 | `Project` thuộc Member 2; chuyển trạng thái, entity và logic lịch sử thuộc Member 3; hai bên thống nhất trường, enum, phương thức | Đã quyết định |
| 2b | Package `history` cho lịch sử | Đề xuất (chưa tạo) |
| 3 | Member 3 sở hữu `ProjectMember`, `PositionAssignment`; Member 2 sở hữu quy trình duyệt đơn; thống nhất transaction boundary | Đề xuất |
| 4 | Member 3 phụ trách API tiến độ; cập nhật hợp đồng API để tách phạm vi | Đề xuất (hợp đồng chưa sửa) |
| 5 | Member 5: tạo/chỉnh sửa dự án, vị trí, ứng viên; Member 4: danh sách, tìm kiếm, chi tiết, gửi/rút đơn | Đề xuất |
| 6 | Member 4 giữ Auth Context, Axios, interceptor | Đã quyết định |
| 7 | Năm branch của Member 3 | Đã quyết định |
| 8 | Ánh xạ tên gọi ↔ họ tên | Một phần có bằng chứng (mục 5) |

### 6.2. Lượt cập nhật hiện tại

| # | Nội dung | Trạng thái | Mục |
|---|----------|------------|-----|
| A1 | Ma trận chuyển trạng thái dự án (dùng `draft`/`open`) | Đề xuất; **không tương thích** enum hiện tại, chưa áp dụng | 2.2.1 |
| A2 | Member 3 chuyển trạng thái dự án; Member 2 đóng `Position` và xử lý `Application` `pending`; Member 1 hỗ trợ ràng buộc và kiểm thử; cùng một giao dịch | Đề xuất. Trạng thái cuối của đơn `pending` chưa thống nhất | 2.9 |
| A3 | Contract tích hợp công khai giữa `project`/`application` và `member`; không truy cập repository nội bộ; không phụ thuộc trực tiếp giữa entity | Đề xuất | 2.10 |
| A4 | Member 2 sở hữu `common/exception`, `common/response`, `GlobalExceptionHandler`, error code; quy trình chuyển lỗi trigger thành lỗi API | Đề xuất | 2.11 |
| A5 | API tiến độ của Member 3 kèm `capacity`, `filled`, `available` | Đề xuất (hợp đồng chưa sửa) | 2.5 |
| A6 | Chia `pages/projects` thành `discovery/` (Member 4) và `management/` (Member 5) | Đề xuất | 2.6 |
| A7 | `feature/task-management` là branch backend của Member 3, tạo từ `develop`, PR vào `develop`, không gộp code frontend | Đã quyết định | 4.1 |
| A8 | Ánh xạ tên gọi ↔ họ tên | Chỉ Nguyệt có bằng chứng trong PDF; các dòng khác chưa xác nhận | 5 |

## 7. Các điểm còn cần nhóm biểu quyết hoặc xác nhận

1. **Ma trận trạng thái dự án:** giữ enum hiện tại (`planning`, `active`, `paused`, `completed`, `cancelled`) và áp dụng bản đối chiếu tên ở 2.2.1, hay đổi sang `draft`/`open` (cần Member 1 sửa schema bằng migration)? Có cho phép chuyển `paused` → `planning` hoặc `completed` → trạng thái khác không?
2. **Trạng thái cuối của `Application` `pending`** khi dự án `completed`/`cancelled` (2.9): giữ `pending`, `rejected` (ai là `processed_by`?), `withdrawn`, hay thêm giá trị mới (đổi schema)?
3. **Tài khoản hệ thống:** `changed_by` và `processed_by` cần người dùng thật; PDF nhắc "tài khoản hệ thống" nhưng schema/seed chưa có.
4. **Đảm nhiệm khi dự án kết thúc:** `position_assignment` đang hiệu lực có kết thúc không? Chuyển `paused` có đóng vị trí không?
5. **Khóa đồng thời** giữa duyệt đơn (Member 2) và chuyển trạng thái (Member 3).
6. **Vị trí interface** của contract tích hợp: phương án A (`service`) hay B (`api`), và cách xử lý vòng phụ thuộc `project` ↔ `member` (2.10).
7. **Chủ sở hữu thực tế** của hai contract bổ sung (đọc `Project`/`Position`; đếm người đang đảm nhiệm) và cách Member 2 lọc "còn chỗ" (FR05).
8. **Định dạng response và error body** (hiện `TODO` trong hợp đồng); danh mục mã lỗi CSDL của Member 1 và nơi lưu tài liệu này.
9. **Tên trường tiến độ** (`capacity/filled/available` hay `slots/remaining_slots`) và phạm vi API tiến độ (2.5).
10. **Cấu trúc `pages/projects`:** vị trí `members`/`tasks`/`applications` so với `discovery/`/`management/`; cách đăng ký route và đóng góp vào `components/` (2.6).
11. **Tên branch frontend** của Member 5 cho giao diện công việc và các branch dùng chung còn lại (4.2).
12. **Package `history`** và các sub-package mới (chưa tạo).
13. **Backup/restore:** Member 1 viết quy trình, Member 5 phụ trách triển khai; ai chạy trên môi trường demo?
14. **Ánh xạ tên gọi ↔ họ tên** các dòng chưa xác nhận ở mục 5.
