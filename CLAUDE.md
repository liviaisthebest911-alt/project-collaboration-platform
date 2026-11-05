# CLAUDE.md

Tệp này hướng dẫn Claude Code (claude.ai/code) khi làm việc với mã nguồn trong repository này. Toàn bộ trao đổi và tài liệu phải dùng tiếng Việt; giữ nguyên tên kỹ thuật, tên file, đường dẫn, class, method và biến.

## Tổng quan

Nền tảng kết nối nhân sự và quản lý dự án, nối những người dùng có kỹ năng với các dự án phần mềm cần người đóng góp (monorepo: PostgreSQL + Spring Boot + React). Hệ thống **cố ý không** tích hợp GitHub/GitLab; đường dẫn kho mã của dự án chỉ được lưu để tham khảo.

Repository hiện là một **skeleton** (khung dự án): schema CSDL và dữ liệu mẫu đã có, nhưng các package backend (`auth`, `user`, `skill`, `project`, `position`, `application`, `member`, `task`, `handover`, `security`, `config`, `common/*`) chỉ chứa `.gitkeep`, còn frontend chỉ có `App.tsx`, `main.tsx` và Axios instance dùng chung trong `services/api.ts`.

Tài liệu ngữ cảnh đầy đủ: `docs/PROJECT_CONTEXT.md`. Phân công và quy tắc phối hợp: `docs/TEAM_WORKFLOW.md`.

## Lệnh thường dùng

Database (PostgreSQL 16 qua Docker; cần `.env` sao chép từ `.env.example` và đặt `POSTGRES_PASSWORD`):
```bash
docker compose up -d
docker compose exec postgres psql -U project_collab_user -d project_collab
docker compose exec -T postgres psql -U project_collab_user -d project_collab < database/schema/001_create_tables.sql
docker compose down -v      # xóa toàn bộ dữ liệu
```

Backend (JDK 21+, Maven; phải export biến môi trường từ `.env` trước; `JWT_SECRET`, `DB_USERNAME`, `DB_PASSWORD` không có giá trị mặc định):
```bash
set -a; source .env; set +a
cd backend && mvn spring-boot:run -Dspring-boot.run.profiles=dev
cd backend && mvn test
cd backend && mvn test -Dtest=ClassName#methodName   # chạy một test
cd backend && mvn -B verify                           # lệnh CI chạy
```

Frontend (Node 20+, chạy trong `frontend/`; sao chép `.env.example` thành `.env` trước):
```bash
npm install
npm run dev        # http://localhost:5173
npm run build      # tsc --noEmit && vite build — CI chạy lệnh này; không có script lint hay test
```

## Kiến trúc

- **SQL là nguồn sự thật của schema.** `spring.jpa.hibernate.ddl-auto` là `none`; JPA entity phải viết theo `database/schema/001_create_tables.sql`, không làm ngược lại. Thay đổi schema đi qua chủ sở hữu database (Member 1) và một PR, các thay đổi sau này là script có thứ tự trong `database/migrations/` (`V002__add_xxx.sql`). Script schema kiểm tra `current_database() = 'project_collab'`, chạy trong một giao dịch và yêu cầu CSDL rỗng. Dữ liệu mẫu (`database/seeds/002_sample_data.sql`) phải là dữ liệu giả rõ ràng.
- **Mô hình miền** (các bảng trong `001_create_tables.sql`): `users`, `domain`, `skill`, `skill_domain`, `user_skill` (level 1–5), `project`, `project_domain`, `position`, `position_skill_requirement`, `application`, `project_member`, `position_assignment`, `task`, `task_assignment`, `project_status_history`, `project_handover`. Luồng: người dùng ứng tuyển vào `position` → đơn được chấp nhận trở thành `project_member`/`position_assignment` → công việc được giao cho thành viên; đổi trạng thái và bàn giao owner được ghi vào các bảng lịch sử. Các quy tắc nghiệp vụ liên bảng và trigger được lên kế hoạch cho `database/triggers` / `functions`, chưa được viết.
- **Backend** là một ứng dụng Spring Boot duy nhất, package gốc `com.projectcollab`, tổ chức theo tính năng (package-by-feature). Quyền sở hữu module được chia theo phân công thành viên (xem mục "Quy tắc làm việc theo phân công thành viên"). Cấu hình trong `application.yml` (profile mặc định `dev`, `open-in-view: false`, JWT secret và thời hạn, CORS origin lấy từ biến môi trường) và `application-dev.yml`.
- **Frontend** là React 18 + Vite + TypeScript + Tailwind với React Router; các trang được nhóm theo tính năng trong `src/pages/`. Axios instance dùng chung (`services/api.ts`, base URL từ `VITE_API_BASE_URL`) và Auth Context do Member 4 xây dựng và Member 5 dùng lại; interceptor gắn header `Authorization` JWT hiện vẫn là TODO.

## Quy tắc quy trình (Workflow)

- **API contract trước:** mọi thay đổi endpoint phải được ghi vào `docs/api/API_CONTRACT.md` trong một PR nhỏ *trước khi* cài đặt. Không tự ý sửa file này.
- Tạo branch từ `develop` (`feature/<tên>`, `fix/<tên>`), mở PR vào `develop`; không push trực tiếp vào `main` hoặc `develop`. `develop` chỉ merge vào `main` ở các mốc demo ổn định. Xem `CONTRIBUTING.md` và `docs/TEAM_WORKFLOW.md`.
- CI (`.github/workflows/ci.yml`) chạy `mvn -B verify` (Java 21) và `npm ci && npm run build` trên PR và push vào `develop`/`main`.

## Quy tắc làm việc theo phân công thành viên

Nguồn: phân công chính thức của nhóm trong `docs/TEAM_WORKFLOW.md`. Tên trong ngoặc là tên gọi trong nhóm. Nhãn **[Đã quyết định]** nghĩa là áp dụng ngay; **[Đề xuất]** nghĩa là chờ nhóm xác nhận, **không được coi là chính thức** và không được cài đặt như thể đã chốt.

### Phạm vi từng Member

| Member | Vai trò | Sở hữu |
|--------|---------|--------|
| 1 (Mỡ) | Database Developer kiêm Business Analyst | `database/` (schema, migrations, seeds, views, queries); **[Đề xuất]** cả `database/triggers`, `database/functions`, constraints, indexes, ràng buộc liên bảng, danh mục mã lỗi trigger; `docs/requirements`, `docs/database` |
| 2 (GL) | Backend: tài khoản và tuyển dụng | `auth`, `user`, `skill`, `project` (gồm entity `Project`), `position`, `application`, `security`, `config`; giao dịch tạo dự án, duyệt đơn; kiểm tra quyền owner; tìm kiếm/lọc/phân trang/gợi ý. **[Đề xuất]** thêm: đóng `Position` và xử lý `Application` `pending` khi dự án kết thúc; `common/exception`, `common/response`, `GlobalExceptionHandler`, error code |
| 3 (Liu) | Backend: cộng tác và quản lý dự án | `member`, `task`, `handover`; logic chuyển trạng thái dự án; entity và logic lịch sử trạng thái; `last_activity_at` và cảnh báo đình trệ; giao dịch rời dự án và chuyển owner. **[Đề xuất]** thêm: `ProjectMember`, `PositionAssignment`, API tiến độ (có `capacity`, `filled`, `available`), exception nghiệp vụ module mình |
| 4 (Nguyệt) | Frontend kiêm UI/UX | `components/` dùng chung, Auth Context, Axios instance và interceptor, `pages/auth`, `profile`; **[Đề xuất]** `pages/projects/discovery/` (danh sách, tìm kiếm, chi tiết dự án, gửi/rút đơn), `pages/applications` |
| 5 (Miu) | Frontend kiêm Deployment | `pages/members`, `tasks`; **[Đề xuất]** `pages/projects/management/` (dự án của tôi, tạo/sửa dự án, vị trí, ứng viên, thành viên, task, tiến độ, bàn giao); `deployment/`, `.github/workflows`, `docker-compose.yml` |

### Cách xác định phạm vi công việc

- Khi yêu cầu nêu rõ Member nào (ví dụ "việc của Member 3"), chỉ làm trong phạm vi của Member đó theo bảng trên.
- Khi yêu cầu không nêu Member và không rõ thuộc module nào, hỏi lại trước khi sửa.
- Khi người dùng yêu cầu việc thuộc **Member 3**, ưu tiên các mảng: cộng tác, quản lý dự án, công việc, tiến độ, lịch sử và bàn giao. Phạm vi cụ thể: API thành viên/đảm nhiệm/rời dự án; API công việc, giao việc, trạng thái; kiểm tra thành viên đang hoạt động và thuộc đúng dự án; xử lý phân công khi rời dự án; cập nhật `last_activity_at`; chuyển trạng thái dự án và lịch sử; API gửi/hủy/chấp nhận/từ chối bàn giao; giao dịch chuyển owner (luôn đúng một owner hoạt động); kết nối views/truy vấn của Member 1; kiểm thử rollback.
- Branch của Member 3 **[Đã quyết định]**: `feature/member-management`, `feature/member-leaving`, `feature/project-progress`, `feature/project-history`, `feature/owner-handover`, và `feature/task-management` (branch backend). Tất cả tạo từ `develop`, PR vào `develop`. Không gộp code frontend của Member 5 vào `feature/task-management` nếu hai người phát triển độc lập.

### Ranh giới giữa các Member

- **Không tự ý sửa module thuộc Member khác.** Nếu việc cần chạm vào module của Member khác, dừng lại và báo cho người dùng.
- **Không tạo package, class hoặc entity mới** khi chưa được yêu cầu rõ. Package `history`, `GlobalExceptionHandler`, thư mục `discovery/`, `management/`, sub-package `api` đều chỉ là **[Đề xuất]**, chưa tồn tại.
- **Không tạo entity `Project` trùng lặp** và không sửa entity thuộc Member khác.
- **SQL, schema, migration, views, trigger, function thuộc Member 1.** Member 2 và 3 không tự sửa script database của nhau hay của Member 1; nếu cần đổi cấu trúc hoặc ràng buộc, mô tả quy tắc nghiệp vụ và chuyển cho Member 1.
- Member 1 không tự quyết định thay nghiệp vụ của backend.
- Member 2 và 3 thống nhất API với Member 4 và 5 trước khi triển khai; thay đổi endpoint ghi vào `docs/api/API_CONTRACT.md` trước. Không tự sửa file này.
- Member 5 phụ trách triển khai, không mặc nhiên chịu trách nhiệm sửa lỗi của người khác.
- Frontend: Member 4 và 5 không cùng sửa một page/component khi chưa thống nhất; Auth Context và Axios dùng chung do Member 4 phụ trách.

### Trạng thái dự án (quan trọng: tránh sai enum)

- **Enum thực tế** của trạng thái dự án (PDF §1.6, `database/schema/001_create_tables.sql`, seed): `planning`, `active`, `paused`, `completed`, `cancelled`. Trạng thái vị trí: `open`, `closed`.
- Ma trận chuyển trạng thái do nhóm đề xuất dùng `draft` và `open`. Hai giá trị này **không tồn tại** trong schema, PDF hay seed, nên ma trận đó **chưa được áp dụng**. Không đưa `draft`/`open` vào code cho dự án; không tự đổi enum. `open` còn là trạng thái của `position`, dễ nhầm.
- PDF chưa quy định chuyển trạng thái hợp lệ. Cho đến khi nhóm xác nhận ma trận, không cài đặt kiểm tra chuyển trạng thái dựa trên ma trận đề xuất; hỏi người dùng.
- Chi tiết: `docs/TEAM_WORKFLOW.md` mục 2.2.1.

### Phối hợp giữa Member 2 và Member 3

- **`Project`:** entity thuộc Member 2 (package `project`) **[Đã quyết định]**. Logic chuyển trạng thái và lịch sử thuộc Member 3. Hai bên thống nhất trường, enum và phương thức tương tác với `Project` trước khi viết mã. Không sửa `Project` từ phía Member 3 nếu chưa thống nhất.
- **Chuyển trạng thái sang `completed`/`cancelled`** **[Đề xuất]**: Member 3 chuyển trạng thái và ghi lịch sử; Member 2 đóng `Position` và xử lý `Application` `pending`; Member 1 hỗ trợ ràng buộc và kiểm thử CSDL. Tất cả trong cùng một giao dịch. **Trạng thái cuối của `Application` `pending` chưa được thống nhất** (PDF chỉ nói không được chấp nhận); không tự chọn `rejected`, `withdrawn` hay giá trị mới.
- **Duyệt đơn** thuộc Member 2; **tạo thành viên và phân công vị trí** (`ProjectMember`, `PositionAssignment`) **[Đề xuất]** thuộc Member 3. Member 2 dùng contract do Member 3 cung cấp, không ghi trực tiếp vào hai bảng này. Tạo dự án (thêm owner, PDF FR03) cũng dùng contract này.
- **Contract tích hợp** **[Đề xuất]**: dùng interface công khai, tách khỏi entity và repository nội bộ; không truy cập repository nội bộ của module khác; không tạo phụ thuộc trực tiếp giữa entity (tham chiếu bằng `id`); trao đổi bằng DTO. Chiều Member 3 → Member 2 (đóng tuyển dụng) và chiều Member 2 → Member 3 (tạo thành viên/phân công). Vị trí package: ưu tiên phương án A trong `docs/TEAM_WORKFLOW.md` 2.10 (interface trong `service` của module cung cấp) cho đến khi nhóm chọn; không tạo sub-package `api` khi chưa được xác nhận. Cẩn thận với vòng phụ thuộc `project` ↔ `member`.
- **Transaction:** module điều phối mở giao dịch; contract của module kia tham gia giao dịch đó, không mở giao dịch độc lập; không nuốt lỗi; mọi bước cùng thành công hoặc cùng rollback.
- **API tiến độ** **[Đề xuất]** thuộc Member 3, có `capacity`, `filled`, `available`. `capacity` ↔ `position.slots`; `filled` = số `position_assignment` có `ended_at IS NULL` và thành viên có `left_at IS NULL`; `available` = `capacity - filled`. Tên khác với `remaining_slots` trong PDF, chờ xác nhận. `GET /api/projects/{projectId}/progress` trong hợp đồng nháp vẫn nằm ở nhóm Projects; không tự sửa hợp đồng.
- **Kiểm tra quyền owner** thuộc Member 2; Member 3 dùng lại, không viết lặp.
- Giao dịch duyệt đơn (Member 2) và giao dịch rời dự án / bàn giao owner (Member 3) thuộc hai Member khác nhau. Không gộp hay chuyển logic giữa hai bên khi chưa được xác nhận.

### Exception, response và lỗi từ CSDL

- **[Đề xuất]** Member 2 sở hữu cấu trúc dùng chung ban đầu (`common/exception`, `common/response`, `GlobalExceptionHandler`, error code, response lỗi); Member 3 khai báo exception nghiệp vụ của module mình và phối hợp Member 2 để ánh xạ. Định dạng response và error body hiện là `TODO` trong hợp đồng: phải chốt trong hợp đồng trước.
- Khi lỗi đến từ trigger hoặc ràng buộc PostgreSQL: kiểm tra nghiệp vụ ở service trước; ánh xạ bằng SQLSTATE và tên constraint từ ngoại lệ gốc của driver, **không phân tích chuỗi thông báo lỗi**; **không trả lỗi SQL nội bộ cho frontend**; lỗi chưa biết trả mã lỗi chung (500) và chỉ ghi chi tiết vào log. Frontend chỉ dựa vào mã lỗi API. Chi tiết: `docs/TEAM_WORKFLOW.md` 2.11.

### Khi công việc liên quan nhiều module

1. Phân tích trước: các module, bảng và API nào bị ảnh hưởng, thuộc Member nào.
2. Nêu cả rủi ro phụ thuộc giữa các module (ví dụ phụ thuộc vòng giữa `project`, `application` và `member`) và rủi ro đồng thời (duyệt đơn so với chuyển trạng thái dự án).
3. Đề xuất cách phối hợp (ai sửa phần nào, thứ tự, điều cần thống nhất) và chờ người dùng xác nhận.
4. Chỉ thay đổi sau khi đã xác nhận, và chỉ trong phạm vi được đồng ý.

Các điểm chưa chốt (xem `docs/TEAM_WORKFLOW.md` mục 7): ma trận trạng thái dự án; trạng thái cuối của đơn `pending`; tài khoản hệ thống; khóa đồng thời; vị trí interface của contract tích hợp; định dạng error body; tên trường và phạm vi API tiến độ; cấu trúc `pages/projects`. Với việc chạm vào các điểm này, hỏi người dùng trước.
