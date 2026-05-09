<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang quản trị - DocShare</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f8fafc; margin: 0; padding: 0; display: flex; height: 100vh; }
        .sidebar { width: 260px; background-color: #1e293b; color: white; display: flex; flex-direction: column; }
        .sidebar .logo { padding: 20px; font-size: 24px; font-weight: bold; display: flex; align-items: center; gap: 10px; border-bottom: 1px solid #334155; }
        .sidebar a { color: #cbd5e1; text-decoration: none; padding: 15px 20px; display: flex; align-items: center; gap: 10px; transition: 0.2s; }
        .sidebar a:hover, .sidebar a.active { background-color: #334155; color: white; }
        .main-content { flex: 1; display: flex; flex-direction: column; overflow-y: auto; }
        .header { background-color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #e2e8f0; box-shadow: 0 1px 2px rgba(0,0,0,0.05); }
        .header .user-info { display: flex; align-items: center; gap: 15px; }
        .header .btn-logout { background-color: #ef4444; color: white; border: none; padding: 8px 16px; border-radius: 6px; cursor: pointer; text-decoration: none; font-size: 14px; font-weight: 500; transition: 0.2s; }
        .header .btn-logout:hover { background-color: #dc2626; }
        .content { padding: 30px; }
        .card { background-color: white; border-radius: 8px; padding: 25px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
        h1, h2 { margin-top: 0; color: #0f172a; }
    </style>
</head>
<body>

    <aside class="sidebar">
        <div class="logo">
            <span class="material-symbols-outlined">shield_person</span>
            Admin Panel
        </div>
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="active">
            <span class="material-symbols-outlined">dashboard</span>
            Dashboard
        </a>
    </aside>

    <main class="main-content">
        <header class="header">
            <h2>Tổng quan</h2>
            <div class="user-info">
                <span>Xin chào, <strong>${sessionScope.adminUser.fullName}</strong>!</span>
                <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Đăng xuất</a>
            </div>
        </header>
        
        <div class="content">
            <div class="card">
                <h2>Chào mừng bạn đến với trang quản trị</h2>
                <p>Bạn đã đăng nhập thành công với vai trò Quản trị viên.</p>
                <p>Giao diện này hiện là một trang tổng quan cơ bản. Bạn có thể thêm các chức năng khác sau này.</p>
            </div>
        </div>
    </main>

</body>
</html>
