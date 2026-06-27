<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>PlusCard — Virtual Card Platform</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Space+Grotesk:wght@400;500;600;700&display=swap" rel="stylesheet" />
  <style>
    :root {
      --midnight: #0B0F1A;
      --navy: #111827;
      --card-bg: #151C2C;
      --surface: #1E2740;
      --border: #2A3550;
      --plus-blue: #3B82F6;
      --plus-glow: #60A5FA;
      --plus-cyan: #06B6D4;
      --accent-green: #10B981;
      --accent-amber: #F59E0B;
      --text-primary: #F1F5F9;
      --text-secondary: #94A3B8;
      --text-muted: #4B5E7E;
      --error: #EF4444;
      --success: #10B981;
    }

    * { margin: 0; padding: 0; box-sizing: border-box; }

    body {
      font-family: 'Inter', sans-serif;
      background: var(--midnight);
      color: var(--text-primary);
      min-height: 100vh;
      overflow-x: hidden;
    }

    /* ─── PAGES ─────────────────────────────────────────────── */
    .page { display: none; min-height: 100vh; }
    .page.active { display: flex; }

    /* ─── AUTH LAYOUT ────────────────────────────────────────── */
    .auth-layout {
      flex-direction: row;
      min-height: 100vh;
    }

    .auth-panel {
      flex: 1;
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      padding: 48px 40px;
      background: var(--navy);
      position: relative;
    }

    .auth-side {
      width: 480px;
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      justify-content: center;
      padding: 48px;
      background: var(--midnight);
      border-left: 1px solid var(--border);
    }

    /* ─── BRAND ──────────────────────────────────────────────── */
    .brand {
      display: flex;
      align-items: center;
      gap: 10px;
      margin-bottom: 48px;
    }

    .brand-icon {
      width: 36px;
      height: 36px;
      background: linear-gradient(135deg, var(--plus-blue), var(--plus-cyan));
      border-radius: 8px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 18px;
      font-weight: 700;
      font-family: 'Space Grotesk', sans-serif;
      color: white;
    }

    .brand-name {
      font-family: 'Space Grotesk', sans-serif;
      font-size: 22px;
      font-weight: 700;
      color: var(--text-primary);
      letter-spacing: -0.3px;
    }

    .brand-name span {
      color: var(--plus-blue);
    }

    /* ─── HERO VISUAL ─────────────────────────────────────────── */
    .hero-visual {
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 32px;
      text-align: center;
    }

    .virtual-card-preview {
      width: 340px;
      height: 200px;
      border-radius: 20px;
      background: linear-gradient(135deg, #1E3A6E 0%, #0F2657 40%, #0B1A40 100%);
      border: 1px solid rgba(59, 130, 246, 0.3);
      padding: 28px;
      position: relative;
      box-shadow:
        0 0 60px rgba(59, 130, 246, 0.15),
        0 24px 48px rgba(0, 0, 0, 0.5);
      overflow: hidden;
    }

    .virtual-card-preview::before {
      content: '';
      position: absolute;
      top: -40px;
      right: -40px;
      width: 180px;
      height: 180px;
      background: radial-gradient(circle, rgba(59,130,246,0.2) 0%, transparent 70%);
      border-radius: 50%;
    }

    .virtual-card-preview::after {
      content: '';
      position: absolute;
      bottom: -30px;
      left: -30px;
      width: 120px;
      height: 120px;
      background: radial-gradient(circle, rgba(6,182,212,0.15) 0%, transparent 70%);
      border-radius: 50%;
    }

    .card-chip {
      width: 40px;
      height: 30px;
      background: linear-gradient(135deg, #D4AF37, #F5D97A);
      border-radius: 5px;
      margin-bottom: 20px;
      display: grid;
      grid-template-columns: 1fr 1fr;
      grid-template-rows: 1fr 1fr;
      gap: 2px;
      padding: 4px;
    }

    .chip-segment {
      background: rgba(0,0,0,0.25);
      border-radius: 1px;
    }

    .card-number-preview {
      font-family: 'Space Grotesk', sans-serif;
      font-size: 16px;
      letter-spacing: 3px;
      color: rgba(255,255,255,0.85);
      margin-bottom: 20px;
    }

    .card-footer-preview {
      display: flex;
      justify-content: space-between;
      align-items: flex-end;
    }

    .card-label-sm {
      font-size: 9px;
      text-transform: uppercase;
      letter-spacing: 1.5px;
      color: rgba(255,255,255,0.45);
      margin-bottom: 3px;
    }

    .card-value-sm {
      font-family: 'Space Grotesk', sans-serif;
      font-size: 13px;
      color: rgba(255,255,255,0.85);
      letter-spacing: 1px;
    }

    .card-network-badge {
      width: 44px;
      height: 28px;
      display: flex;
      align-items: center;
      gap: -8px;
    }

    .circle-left {
      width: 28px;
      height: 28px;
      border-radius: 50%;
      background: rgba(255,80,80,0.7);
    }

    .circle-right {
      width: 28px;
      height: 28px;
      border-radius: 50%;
      background: rgba(255,180,0,0.7);
      margin-left: -10px;
    }

    .hero-tagline {
      font-family: 'Space Grotesk', sans-serif;
      font-size: 28px;
      font-weight: 700;
      color: var(--text-primary);
      line-height: 1.3;
    }

    .hero-tagline span {
      background: linear-gradient(90deg, var(--plus-blue), var(--plus-cyan));
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
    }

    .hero-sub {
      font-size: 14px;
      color: var(--text-secondary);
      line-height: 1.7;
      max-width: 300px;
    }

    .feature-pills {
      display: flex;
      flex-direction: column;
      gap: 12px;
      width: 100%;
      max-width: 320px;
    }

    .pill {
      display: flex;
      align-items: center;
      gap: 12px;
      padding: 12px 16px;
      background: var(--card-bg);
      border: 1px solid var(--border);
      border-radius: 10px;
    }

    .pill-icon {
      width: 32px;
      height: 32px;
      border-radius: 8px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 15px;
      flex-shrink: 0;
    }

    .pill-icon.blue { background: rgba(59,130,246,0.15); }
    .pill-icon.cyan { background: rgba(6,182,212,0.15); }
    .pill-icon.green { background: rgba(16,185,129,0.15); }

    .pill-text {
      font-size: 13px;
      color: var(--text-secondary);
    }

    .pill-text strong {
      color: var(--text-primary);
      font-weight: 600;
      display: block;
      margin-bottom: 1px;
    }

    /* ─── FORM STYLES ────────────────────────────────────────── */
    .form-header {
      margin-bottom: 36px;
    }

    .form-title {
      font-family: 'Space Grotesk', sans-serif;
      font-size: 26px;
      font-weight: 700;
      color: var(--text-primary);
      margin-bottom: 8px;
    }

    .form-subtitle {
      font-size: 14px;
      color: var(--text-secondary);
    }

    .form-group {
      margin-bottom: 20px;
    }

    .form-group label {
      display: block;
      font-size: 13px;
      font-weight: 500;
      color: var(--text-secondary);
      margin-bottom: 7px;
      letter-spacing: 0.2px;
    }

    .form-row {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 16px;
    }

    input[type="text"],
    input[type="email"],
    input[type="password"],
    input[type="tel"],
    select {
      width: 100%;
      padding: 12px 16px;
      background: var(--surface);
      border: 1px solid var(--border);
      border-radius: 10px;
      color: var(--text-primary);
      font-size: 14px;
      font-family: 'Inter', sans-serif;
      outline: none;
      transition: border-color 0.2s, box-shadow 0.2s;
      appearance: none;
    }

    input:focus, select:focus {
      border-color: var(--plus-blue);
      box-shadow: 0 0 0 3px rgba(59,130,246,0.12);
    }

    input::placeholder { color: var(--text-muted); }

    .input-hint {
      font-size: 12px;
      color: var(--text-muted);
      margin-top: 5px;
    }

    .input-error {
      font-size: 12px;
      color: var(--error);
      margin-top: 5px;
      display: none;
    }

    .btn-primary {
      width: 100%;
      padding: 14px;
      background: linear-gradient(135deg, var(--plus-blue), #2563EB);
      color: white;
      font-size: 15px;
      font-weight: 600;
      font-family: 'Inter', sans-serif;
      border: none;
      border-radius: 10px;
      cursor: pointer;
      transition: opacity 0.2s, transform 0.1s;
      letter-spacing: 0.2px;
    }

    .btn-primary:hover { opacity: 0.9; }
    .btn-primary:active { transform: scale(0.99); }

    .btn-ghost {
      background: transparent;
      border: 1px solid var(--border);
      color: var(--text-secondary);
      padding: 12px 20px;
      border-radius: 10px;
      font-size: 14px;
      font-family: 'Inter', sans-serif;
      cursor: pointer;
      transition: border-color 0.2s, color 0.2s;
    }

    .btn-ghost:hover {
      border-color: var(--plus-blue);
      color: var(--text-primary);
    }

    .divider {
      display: flex;
      align-items: center;
      gap: 12px;
      margin: 24px 0;
    }

    .divider::before, .divider::after {
      content: '';
      flex: 1;
      height: 1px;
      background: var(--border);
    }

    .divider span {
      font-size: 12px;
      color: var(--text-muted);
    }

    .auth-switch {
      text-align: center;
      margin-top: 24px;
      font-size: 14px;
      color: var(--text-secondary);
    }

    .auth-switch a {
      color: var(--plus-blue);
      text-decoration: none;
      font-weight: 500;
      cursor: pointer;
    }

    .auth-switch a:hover { text-decoration: underline; }

    .form-step {
      display: none;
    }

    .form-step.active { display: block; }

    .step-indicator {
      display: flex;
      gap: 8px;
      margin-bottom: 28px;
    }

    .step-dot {
      height: 3px;
      border-radius: 2px;
      transition: all 0.3s;
    }

    .step-dot.active { background: var(--plus-blue); flex: 2; }
    .step-dot.done { background: var(--accent-green); flex: 1; }
    .step-dot.inactive { background: var(--border); flex: 1; }

    .checkbox-row {
      display: flex;
      align-items: flex-start;
      gap: 10px;
      margin-bottom: 20px;
    }

    .checkbox-row input[type="checkbox"] {
      width: 16px;
      height: 16px;
      margin-top: 1px;
      accent-color: var(--plus-blue);
      flex-shrink: 0;
    }

    .checkbox-row label {
      font-size: 13px;
      color: var(--text-secondary);
      cursor: pointer;
      line-height: 1.5;
    }

    .checkbox-row label a {
      color: var(--plus-blue);
      text-decoration: none;
    }

    /* ─── DASHBOARD LAYOUT ───────────────────────────────────── */
    #page-dashboard {
      flex-direction: column;
    }

    .dash-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 0 32px;
      height: 64px;
      background: var(--navy);
      border-bottom: 1px solid var(--border);
      position: sticky;
      top: 0;
      z-index: 100;
    }

    .dash-nav {
      display: flex;
      align-items: center;
      gap: 4px;
    }

    .nav-item {
      display: flex;
      align-items: center;
      gap: 7px;
      padding: 7px 14px;
      border-radius: 8px;
      font-size: 14px;
      font-weight: 500;
      color: var(--text-secondary);
      cursor: pointer;
      transition: background 0.15s, color 0.15s;
      border: none;
      background: none;
      font-family: 'Inter', sans-serif;
    }

    .nav-item:hover { background: var(--surface); color: var(--text-primary); }
    .nav-item.active { background: var(--surface); color: var(--text-primary); }

    .user-menu {
      display: flex;
      align-items: center;
      gap: 10px;
      cursor: pointer;
    }

    .avatar {
      width: 34px;
      height: 34px;
      border-radius: 50%;
      background: linear-gradient(135deg, var(--plus-blue), var(--plus-cyan));
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 13px;
      font-weight: 700;
      color: white;
    }

    .user-name-sm {
      font-size: 14px;
      font-weight: 500;
      color: var(--text-primary);
    }

    .dash-body {
      flex: 1;
      padding: 32px;
      max-width: 1100px;
      margin: 0 auto;
      width: 100%;
    }

    .dash-section { display: none; }
    .dash-section.active { display: block; }

    /* ─── DASHBOARD OVERVIEW ─────────────────────────────────── */
    .greeting {
      margin-bottom: 28px;
    }

    .greeting h2 {
      font-family: 'Space Grotesk', sans-serif;
      font-size: 24px;
      font-weight: 700;
      color: var(--text-primary);
      margin-bottom: 4px;
    }

    .greeting p {
      font-size: 14px;
      color: var(--text-secondary);
    }

    .stats-row {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 16px;
      margin-bottom: 28px;
    }

    .stat-card {
      background: var(--card-bg);
      border: 1px solid var(--border);
      border-radius: 14px;
      padding: 20px;
    }

    .stat-label {
      font-size: 12px;
      color: var(--text-muted);
      text-transform: uppercase;
      letter-spacing: 0.8px;
      margin-bottom: 10px;
    }

    .stat-value {
      font-family: 'Space Grotesk', sans-serif;
      font-size: 26px;
      font-weight: 700;
      color: var(--text-primary);
      margin-bottom: 6px;
    }

    .stat-trend {
      font-size: 12px;
      display: flex;
      align-items: center;
      gap: 4px;
    }

    .stat-trend.up { color: var(--accent-green); }
    .stat-trend.neutral { color: var(--text-muted); }

    .dashboard-grid {
      display: grid;
      grid-template-columns: 1fr 340px;
      gap: 24px;
    }

    /* ─── ACTIVE CARD DISPLAY ─────────────────────────────────── */
    .card-display-area {
      background: var(--card-bg);
      border: 1px solid var(--border);
      border-radius: 16px;
      padding: 24px;
    }

    .section-title {
      font-family: 'Space Grotesk', sans-serif;
      font-size: 16px;
      font-weight: 600;
      color: var(--text-primary);
      margin-bottom: 20px;
      display: flex;
      align-items: center;
      justify-content: space-between;
    }

    .badge {
      font-size: 11px;
      font-weight: 600;
      padding: 3px 10px;
      border-radius: 20px;
      font-family: 'Inter', sans-serif;
    }

    .badge.active { background: rgba(16,185,129,0.15); color: var(--accent-green); }
    .badge.frozen { background: rgba(59,130,246,0.15); color: var(--plus-blue); }
    .badge.pending { background: rgba(245,158,11,0.15); color: var(--accent-amber); }

    .virtual-card {
      width: 100%;
      max-width: 360px;
      height: 210px;
      border-radius: 18px;
      background: linear-gradient(135deg, #1A3A7A 0%, #0F2457 50%, #091640 100%);
      border: 1px solid rgba(59,130,246,0.25);
      padding: 24px;
      position: relative;
      margin: 0 auto 24px;
      box-shadow: 0 20px 40px rgba(0,0,0,0.4), 0 0 0 1px rgba(255,255,255,0.04);
      overflow: hidden;
    }

    .virtual-card::before {
      content: '';
      position: absolute;
      top: -50px;
      right: -50px;
      width: 200px;
      height: 200px;
      background: radial-gradient(circle, rgba(59,130,246,0.18) 0%, transparent 70%);
      border-radius: 50%;
    }

    .vc-top {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      margin-bottom: 16px;
    }

    .vc-logo {
      font-family: 'Space Grotesk', sans-serif;
      font-size: 14px;
      font-weight: 700;
      color: rgba(255,255,255,0.8);
    }

    .vc-type {
      font-size: 10px;
      text-transform: uppercase;
      letter-spacing: 1.5px;
      color: rgba(255,255,255,0.4);
      margin-top: 2px;
    }

    .vc-chip {
      width: 36px;
      height: 26px;
      background: linear-gradient(135deg, #C9A227, #E8C84A);
      border-radius: 4px;
    }

    .vc-number {
      font-family: 'Space Grotesk', sans-serif;
      font-size: 17px;
      letter-spacing: 3.5px;
      color: rgba(255,255,255,0.9);
      margin-bottom: 20px;
    }

    .vc-bottom {
      display: flex;
      justify-content: space-between;
      align-items: flex-end;
    }

    .vc-field-label {
      font-size: 9px;
      text-transform: uppercase;
      letter-spacing: 1.5px;
      color: rgba(255,255,255,0.4);
      margin-bottom: 3px;
    }

    .vc-field-value {
      font-family: 'Space Grotesk', sans-serif;
      font-size: 13px;
      color: rgba(255,255,255,0.9);
    }

    .vc-network {
      display: flex;
      align-items: center;
    }

    .vc-circle-a {
      width: 26px;
      height: 26px;
      border-radius: 50%;
      background: rgba(235, 67, 53, 0.75);
    }

    .vc-circle-b {
      width: 26px;
      height: 26px;
      border-radius: 50%;
      background: rgba(251, 188, 4, 0.75);
      margin-left: -10px;
    }

    .card-actions {
      display: flex;
      gap: 10px;
    }

    .card-action-btn {
      flex: 1;
      padding: 10px;
      border-radius: 10px;
      border: 1px solid var(--border);
      background: var(--surface);
      color: var(--text-secondary);
      font-size: 13px;
      font-family: 'Inter', sans-serif;
      font-weight: 500;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 6px;
      transition: all 0.15s;
    }

    .card-action-btn:hover {
      border-color: var(--plus-blue);
      color: var(--text-primary);
      background: rgba(59,130,246,0.06);
    }

    /* ─── TRANSACTIONS ───────────────────────────────────────── */
    .tx-list {
      display: flex;
      flex-direction: column;
      gap: 0;
    }

    .tx-item {
      display: flex;
      align-items: center;
      gap: 14px;
      padding: 14px 0;
      border-bottom: 1px solid var(--border);
    }

    .tx-item:last-child { border-bottom: none; }

    .tx-icon {
      width: 38px;
      height: 38px;
      border-radius: 10px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 16px;
      flex-shrink: 0;
    }

    .tx-icon.shop { background: rgba(59,130,246,0.12); }
    .tx-icon.food { background: rgba(245,158,11,0.12); }
    .tx-icon.travel { background: rgba(16,185,129,0.12); }
    .tx-icon.sub { background: rgba(139,92,246,0.12); }
    .tx-icon.transfer { background: rgba(6,182,212,0.12); }

    .tx-info { flex: 1; }

    .tx-name {
      font-size: 14px;
      font-weight: 500;
      color: var(--text-primary);
    }

    .tx-date {
      font-size: 12px;
      color: var(--text-muted);
      margin-top: 2px;
    }

    .tx-amount {
      font-family: 'Space Grotesk', sans-serif;
      font-size: 15px;
      font-weight: 600;
    }

    .tx-amount.debit { color: var(--text-primary); }
    .tx-amount.credit { color: var(--accent-green); }

    /* ─── QUICK ACTIONS SIDEBAR ──────────────────────────────── */
    .sidebar-panel {
      display: flex;
      flex-direction: column;
      gap: 16px;
    }

    .quick-actions {
      background: var(--card-bg);
      border: 1px solid var(--border);
      border-radius: 16px;
      padding: 20px;
    }

    .action-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 10px;
    }

    .action-tile {
      background: var(--surface);
      border: 1px solid var(--border);
      border-radius: 12px;
      padding: 16px 12px;
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 8px;
      cursor: pointer;
      transition: all 0.15s;
      text-align: center;
    }

    .action-tile:hover {
      border-color: var(--plus-blue);
      background: rgba(59,130,246,0.05);
    }

    .action-tile-icon {
      font-size: 22px;
    }

    .action-tile-label {
      font-size: 12px;
      font-weight: 500;
      color: var(--text-secondary);
    }

    .spend-card {
      background: var(--card-bg);
      border: 1px solid var(--border);
      border-radius: 16px;
      padding: 20px;
    }

    .spend-bar-row {
      margin-top: 12px;
      display: flex;
      flex-direction: column;
      gap: 12px;
    }

    .spend-item {
      display: flex;
      flex-direction: column;
      gap: 6px;
    }

    .spend-label-row {
      display: flex;
      justify-content: space-between;
      font-size: 13px;
    }

    .spend-label { color: var(--text-secondary); }
    .spend-amount { color: var(--text-primary); font-weight: 500; }

    .spend-bar-bg {
      height: 5px;
      border-radius: 3px;
      background: var(--border);
      overflow: hidden;
    }

    .spend-bar-fill {
      height: 100%;
      border-radius: 3px;
      transition: width 0.8s ease;
    }

    /* ─── CARDS PAGE ─────────────────────────────────────────── */
    .cards-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
      gap: 20px;
      margin-top: 24px;
    }

    .card-tile {
      background: var(--card-bg);
      border: 1px solid var(--border);
      border-radius: 16px;
      overflow: hidden;
    }

    .card-tile-card {
      height: 160px;
      padding: 20px;
      position: relative;
      overflow: hidden;
      display: flex;
      flex-direction: column;
      justify-content: space-between;
    }

    .card-tile-card.blue {
      background: linear-gradient(135deg, #1A3A7A, #0F2457);
    }

    .card-tile-card.purple {
      background: linear-gradient(135deg, #2D1B69, #1A0F4A);
    }

    .card-tile-card.teal {
      background: linear-gradient(135deg, #0F4A4A, #062E2E);
    }

    .card-tile-card::before {
      content: '';
      position: absolute;
      top: -30px;
      right: -30px;
      width: 120px;
      height: 120px;
      background: radial-gradient(circle, rgba(255,255,255,0.08) 0%, transparent 70%);
      border-radius: 50%;
    }

    .card-tile-footer {
      padding: 16px 20px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      border-top: 1px solid var(--border);
    }

    .card-tile-name {
      font-weight: 600;
      font-size: 14px;
      color: var(--text-primary);
    }

    .card-tile-limit {
      font-size: 12px;
      color: var(--text-muted);
      margin-top: 2px;
    }

    .new-card-tile {
      background: var(--card-bg);
      border: 2px dashed var(--border);
      border-radius: 16px;
      min-height: 220px;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      gap: 12px;
      cursor: pointer;
      transition: border-color 0.15s;
    }

    .new-card-tile:hover { border-color: var(--plus-blue); }

    .new-card-icon {
      width: 48px;
      height: 48px;
      border-radius: 50%;
      background: var(--surface);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 22px;
    }

    .new-card-label {
      font-size: 14px;
      font-weight: 500;
      color: var(--text-secondary);
    }

    /* ─── SETTINGS ───────────────────────────────────────────── */
    .settings-grid {
      display: grid;
      grid-template-columns: 220px 1fr;
      gap: 24px;
      margin-top: 24px;
    }

    .settings-nav {
      display: flex;
      flex-direction: column;
      gap: 4px;
    }

    .settings-nav-item {
      padding: 9px 14px;
      border-radius: 8px;
      font-size: 14px;
      color: var(--text-secondary);
      cursor: pointer;
      transition: background 0.15s, color 0.15s;
      display: flex;
      align-items: center;
      gap: 9px;
    }

    .settings-nav-item:hover { background: var(--surface); color: var(--text-primary); }
    .settings-nav-item.active { background: var(--surface); color: var(--text-primary); }

    .settings-panel {
      background: var(--card-bg);
      border: 1px solid var(--border);
      border-radius: 16px;
      padding: 28px;
    }

    .settings-section-title {
      font-family: 'Space Grotesk', sans-serif;
      font-size: 18px;
      font-weight: 600;
      color: var(--text-primary);
      margin-bottom: 24px;
      padding-bottom: 16px;
      border-bottom: 1px solid var(--border);
    }

    .settings-row {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 16px 0;
      border-bottom: 1px solid var(--border);
    }

    .settings-row:last-child { border-bottom: none; }

    .settings-row-info h4 {
      font-size: 14px;
      font-weight: 500;
      color: var(--text-primary);
      margin-bottom: 3px;
    }

    .settings-row-info p {
      font-size: 12px;
      color: var(--text-muted);
    }

    /* Toggle switch */
    .toggle {
      position: relative;
      width: 44px;
      height: 24px;
      flex-shrink: 0;
    }

    .toggle input { opacity: 0; width: 0; height: 0; }

    .toggle-slider {
      position: absolute;
      cursor: pointer;
      inset: 0;
      background: var(--border);
      border-radius: 24px;
      transition: background 0.2s;
    }

    .toggle-slider::before {
      content: '';
      position: absolute;
      height: 18px;
      width: 18px;
      left: 3px;
      top: 3px;
      background: white;
      border-radius: 50%;
      transition: transform 0.2s;
    }

    .toggle input:checked + .toggle-slider { background: var(--plus-blue); }
    .toggle input:checked + .toggle-slider::before { transform: translateX(20px); }

    /* ─── TOAST ──────────────────────────────────────────────── */
    .toast {
      position: fixed;
      bottom: 28px;
      right: 28px;
      background: var(--card-bg);
      border: 1px solid var(--border);
      border-radius: 12px;
      padding: 14px 20px;
      display: flex;
      align-items: center;
      gap: 12px;
      font-size: 14px;
      color: var(--text-primary);
      box-shadow: 0 8px 32px rgba(0,0,0,0.4);
      z-index: 999;
      transform: translateY(80px);
      opacity: 0;
      transition: all 0.3s ease;
    }

    .toast.show { transform: translateY(0); opacity: 1; }
    .toast.success .toast-dot { background: var(--accent-green); }
    .toast.error .toast-dot { background: var(--error); }

    .toast-dot {
      width: 8px;
      height: 8px;
      border-radius: 50%;
      flex-shrink: 0;
    }

    /* ─── MISC ───────────────────────────────────────────────── */
    .text-link {
      color: var(--plus-blue);
      text-decoration: none;
      font-size: 13px;
      font-weight: 500;
    }

    .text-link:hover { text-decoration: underline; }

    .back-link {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      color: var(--text-secondary);
      font-size: 13px;
      cursor: pointer;
      margin-bottom: 28px;
      transition: color 0.15s;
    }

    .back-link:hover { color: var(--text-primary); }

    .alert-box {
      padding: 12px 16px;
      border-radius: 10px;
      font-size: 13px;
      margin-bottom: 20px;
      display: flex;
      align-items: flex-start;
      gap: 10px;
    }

    .alert-box.info {
      background: rgba(59,130,246,0.1);
      border: 1px solid rgba(59,130,246,0.25);
      color: var(--plus-glow);
    }

    .alert-box.success {
      background: rgba(16,185,129,0.1);
      border: 1px solid rgba(16,185,129,0.25);
      color: var(--accent-green);
    }

    /* ─── RESPONSIVE ─────────────────────────────────────────── */
    @media (max-width: 900px) {
      .auth-side { width: 100%; border-left: none; }
      .auth-panel { display: none; }
      .auth-layout { flex-direction: column; }

      .stats-row { grid-template-columns: 1fr 1fr; }
      .dashboard-grid { grid-template-columns: 1fr; }
      .settings-grid { grid-template-columns: 1fr; }
    }

    @media (max-width: 600px) {
      .auth-side { padding: 32px 24px; }
      .dash-body { padding: 20px 16px; }
      .form-row { grid-template-columns: 1fr; }
      .stats-row { grid-template-columns: 1fr; }
    }
  </style>
</head>
<body>

<!-- ══════════════════════════════════════════════════════════ -->
<!-- PAGE: LOGIN                                                -->
<!-- ══════════════════════════════════════════════════════════ -->
<div id="page-login" class="page auth-layout active">

  <div class="auth-panel">
    <div class="hero-visual">
      <div class="virtual-card-preview">
        <div class="card-chip">
          <div class="chip-segment"></div>
          <div class="chip-segment"></div>
          <div class="chip-segment"></div>
          <div class="chip-segment"></div>
        </div>
        <div class="card-number-preview">•••• •••• •••• 4291</div>
        <div class="card-footer-preview">
          <div>
            <div class="card-label-sm">Expires</div>
            <div class="card-value-sm">09 / 27</div>
          </div>
          <div>
            <div class="card-label-sm">Balance</div>
            <div class="card-value-sm">$2,450.00</div>
          </div>
          <div class="card-network-badge">
            <div class="circle-left"></div>
            <div class="circle-right"></div>
          </div>
        </div>
      </div>

      <div>
        <div class="hero-tagline">Your card,<br><span>everywhere online.</span></div>
        <p class="hero-sub" style="margin: 12px auto 0;">Secure virtual cards for global online purchases. No physical card needed.</p>
      </div>

      <div class="feature-pills">
        <div class="pill">
          <div class="pill-icon blue">🔐</div>
          <div class="pill-text"><strong>End-to-End Encrypted</strong>All transactions protected by bank-grade security</div>
        </div>
        <div class="pill">
          <div class="pill-icon cyan">⚡</div>
          <div class="pill-text"><strong>Instant Activation</strong>Generate a virtual card in under 60 seconds</div>
        </div>
        <div class="pill">
          <div class="pill-icon green">🌍</div>
          <div class="pill-text"><strong>Accepted Worldwide</strong>Works on any international merchant or platform</div>
        </div>
      </div>
    </div>
  </div>

  <div class="auth-side">
    <div class="brand">
      <div class="brand-icon">+</div>
      <div class="brand-name">Plus<span>Card</span></div>
    </div>

    <div class="form-header">
      <div class="form-title">Welcome back</div>
      <div class="form-subtitle">Sign in to access your virtual cards</div>
    </div>

    <div class="form-group">
      <label>Email address</label>
      <input type="email" id="login-email" placeholder="you@example.com" />
    </div>

    <div class="form-group">
      <label>Password</label>
      <input type="password" id="login-password" placeholder="Enter your password" />
      <div class="input-hint" style="text-align: right;"><a class="text-link">Forgot password?</a></div>
    </div>

    <div class="alert-box info" id="login-error" style="display:none;">
      ⚠️ Invalid email or password. Please try again.
    </div>

    <button class="btn-primary" onclick="handleLogin()">Sign in</button>

    <div class="divider"><span>or</span></div>

    <div class="auth-switch">
      Don't have an account? <a onclick="showPage('page-register')">Create one — it's free</a>
    </div>
  </div>
</div>


<!-- ══════════════════════════════════════════════════════════ -->
<!-- PAGE: REGISTER                                             -->
<!-- ══════════════════════════════════════════════════════════ -->
<div id="page-register" class="page auth-layout">

  <div class="auth-panel">
    <div class="hero-visual">
      <div class="virtual-card-preview">
        <div class="card-chip">
          <div class="chip-segment"></div>
          <div class="chip-segment"></div>
          <div class="chip-segment"></div>
          <div class="chip-segment"></div>
        </div>
        <div class="card-number-preview">•••• •••• •••• ????</div>
        <div class="card-footer-preview">
          <div>
            <div class="card-label-sm">Your name</div>
            <div class="card-value-sm">— / —</div>
          </div>
          <div>
            <div class="card-label-sm">Status</div>
            <div class="card-value-sm">Pending</div>
          </div>
          <div class="card-network-badge">
            <div class="circle-left"></div>
            <div class="circle-right"></div>
          </div>
        </div>
      </div>

      <div>
        <div class="hero-tagline">Your first card<br><span>starts here.</span></div>
        <p class="hero-sub" style="margin: 12px auto 0;">Create an account in minutes. Your virtual card is ready the moment you verify.</p>
      </div>

      <div class="feature-pills">
        <div class="pill">
          <div class="pill-icon blue">💳</div>
          <div class="pill-text"><strong>Multiple Cards</strong>Create separate cards per subscription or merchant</div>
        </div>
        <div class="pill">
          <div class="pill-icon green">🛡️</div>
          <div class="pill-text"><strong>Spend Limits</strong>Set a cap on each card to control your budget</div>
        </div>
        <div class="pill">
          <div class="pill-icon cyan">📊</div>
          <div class="pill-text"><strong>Real-Time Tracking</strong>Every transaction shown the moment it happens</div>
        </div>
      </div>
    </div>
  </div>

  <div class="auth-side">
    <div class="brand">
      <div class="brand-icon">+</div>
      <div class="brand-name">Plus<span>Card</span></div>
    </div>

    <div class="back-link" onclick="showPage('page-login')">
      ← Back to sign in
    </div>

    <!-- Step indicator -->
    <div class="step-indicator" id="step-indicator">
      <div class="step-dot active" id="dot-1"></div>
      <div class="step-dot inactive" id="dot-2"></div>
      <div class="step-dot inactive" id="dot-3"></div>
    </div>

    <!-- Step 1: Personal info -->
    <div class="form-step active" id="reg-step-1">
      <div class="form-header">
        <div class="form-title">Create account</div>
        <div class="form-subtitle">Step 1 of 3 — Your details</div>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label>First name</label>
          <input type="text" id="reg-fname" placeholder="First" />
        </div>
        <div class="form-group">
          <label>Last name</label>
          <input type="text" id="reg-lname" placeholder="Last" />
        </div>
      </div>

      <div class="form-group">
        <label>Email address</label>
        <input type="email" id="reg-email" placeholder="you@example.com" />
      </div>

      <div class="form-group">
        <label>Phone number</label>
        <input type="tel" id="reg-phone" placeholder="+254 700 000 000" />
        <div class="input-hint">For verification and fraud protection</div>
      </div>

      <button class="btn-primary" onclick="regNextStep(1)">Continue</button>
    </div>

    <!-- Step 2: Account security -->
    <div class="form-step" id="reg-step-2">
      <div class="form-header">
        <div class="form-title">Set a password</div>
        <div class="form-subtitle">Step 2 of 3 — Account security</div>
      </div>

      <div class="form-group">
        <label>Password</label>
        <input type="password" id="reg-pass" placeholder="At least 8 characters" />
        <div class="input-hint">Use a mix of letters, numbers, and symbols</div>
      </div>

      <div class="form-group">
        <label>Confirm password</label>
        <input type="password" id="reg-pass2" placeholder="Repeat your password" />
        <div class="input-error" id="pass-mismatch">Passwords don't match</div>
      </div>

      <div class="form-group">
        <label>Country of residence</label>
        <select id="reg-country">
          <option value="">Select country…</option>
          <option>Kenya</option>
          <option>Uganda</option>
          <option>Tanzania</option>
          <option>Nigeria</option>
          <option>Ghana</option>
          <option>South Africa</option>
          <option>United States</option>
          <option>United Kingdom</option>
          <option>Germany</option>
          <option>Other</option>
        </select>
      </div>

      <div style="display: flex; gap: 10px;">
        <button class="btn-ghost" onclick="regBackStep(2)" style="flex:1;">Back</button>
        <button class="btn-primary" onclick="regNextStep(2)" style="flex:2;">Continue</button>
      </div>
    </div>

    <!-- Step 3: Preferences & agree -->
    <div class="form-step" id="reg-step-3">
      <div class="form-header">
        <div class="form-title">Almost there</div>
        <div class="form-subtitle">Step 3 of 3 — Preferences</div>
      </div>

      <div class="form-group">
        <label>Primary currency</label>
        <select id="reg-currency">
          <option value="USD">USD — US Dollar</option>
          <option value="KES">KES — Kenyan Shilling</option>
          <option value="EUR">EUR — Euro</option>
          <option value="GBP">GBP — British Pound</option>
          <option value="UGX">UGX — Ugandan Shilling</option>
          <option value="NGN">NGN — Nigerian Naira</option>
          <option value="ZAR">ZAR — South African Rand</option>
        </select>
      </div>

      <div class="form-group">
        <label>Intended use</label>
        <select id="reg-use">
          <option value="">Choose one…</option>
          <option>Online shopping & subscriptions</option>
          <option>Business & freelancing</option>
          <option>Travel & bookings</option>
          <option>Gaming & digital platforms</option>
          <option>Other</option>
        </select>
      </div>

      <div class="checkbox-row">
        <input type="checkbox" id="terms-agree" />
        <label for="terms-agree">I agree to the <a>Terms of Service</a> and <a>Privacy Policy</a>, and confirm I am at least 18 years old.</label>
      </div>

      <div class="checkbox-row">
        <input type="checkbox" id="marketing-agree" />
        <label for="marketing-agree">Send me updates on new features and security alerts (optional)</label>
      </div>

      <div style="display: flex; gap: 10px;">
        <button class="btn-ghost" onclick="regBackStep(3)" style="flex:1;">Back</button>
        <button class="btn-primary" onclick="handleRegister()" style="flex:2;">Create account</button>
      </div>
    </div>

    <!-- Step 4: Success -->
    <div class="form-step" id="reg-step-4">
      <div style="text-align: center; padding: 20px 0;">
        <div style="font-size: 56px; margin-bottom: 20px;">✅</div>
        <div class="form-title" style="margin-bottom: 8px;">Account created!</div>
        <p style="color: var(--text-secondary); font-size: 14px; margin-bottom: 28px; line-height: 1.7;">
          Your PlusCard account is ready. We've sent a verification link to your email address.
        </p>
        <div class="alert-box success">✓ Verification email sent — check your inbox</div>
        <button class="btn-primary" onclick="goToDashboard()">Go to my dashboard</button>
      </div>
    </div>

    <div class="auth-switch" id="reg-login-switch">
      Already have an account? <a onclick="showPage('page-login')">Sign in</a>
    </div>
  </div>
</div>


<!-- ══════════════════════════════════════════════════════════ -->
<!-- PAGE: DASHBOARD                                            -->
<!-- ══════════════════════════════════════════════════════════ -->
<div id="page-dashboard" class="page" style="flex-direction: column;">

  <!-- Header -->
  <header class="dash-header">
    <div style="display: flex; align-items: center; gap: 28px;">
      <div class="brand">
        <div class="brand-icon">+</div>
        <div class="brand-name">Plus<span>Card</span></div>
      </div>
      <nav class="dash-nav">
        <button class="nav-item active" onclick="switchSection('overview', this)">🏠 Overview</button>
        <button class="nav-item" onclick="switchSection('cards', this)">💳 Cards</button>
        <button class="nav-item" onclick="switchSection('transactions', this)">📋 Transactions</button>
        <button class="nav-item" onclick="switchSection('settings', this)">⚙️ Settings</button>
      </nav>
    </div>

    <div class="user-menu">
      <div class="avatar" id="dash-avatar">JD</div>
      <div class="user-name-sm" id="dash-name">John D.</div>
      <button class="btn-ghost" onclick="handleLogout()" style="padding: 7px 14px; font-size: 13px; margin-left: 8px;">Sign out</button>
    </div>
  </header>

  <!-- Body -->
  <div class="dash-body">

    <!-- SECTION: Overview -->
    <div id="section-overview" class="dash-section active">
      <div class="greeting">
        <h2>Good day, <span id="greeting-name">there</span> 👋</h2>
        <p id="greeting-date">Loading…</p>
      </div>

      <div class="stats-row">
        <div class="stat-card">
          <div class="stat-label">Total Balance</div>
          <div class="stat-value">$2,450</div>
          <div class="stat-trend up">↑ +$320 this month</div>
        </div>
        <div class="stat-card">
          <div class="stat-label">Active Cards</div>
          <div class="stat-value">3</div>
          <div class="stat-trend neutral">1 frozen</div>
        </div>
        <div class="stat-card">
          <div class="stat-label">Spent This Month</div>
          <div class="stat-value">$847</div>
          <div class="stat-trend up">↑ On track</div>
        </div>
        <div class="stat-card">
          <div class="stat-label">Transactions</div>
          <div class="stat-value">24</div>
          <div class="stat-trend neutral">Last 30 days</div>
        </div>
      </div>

      <div class="dashboard-grid">
        <!-- Main: card + transactions -->
        <div class="card-display-area">
          <div class="section-title">
            Primary Card <span class="badge active">Active</span>
          </div>

          <div class="virtual-card">
            <div class="vc-top">
              <div>
                <div class="vc-logo">PlusCard</div>
                <div class="vc-type">Virtual Card</div>
              </div>
              <div class="vc-chip"></div>
            </div>

            <div class="vc-number">4291 •••• •••• 8823</div>

            <div class="vc-bottom">
              <div>
                <div class="vc-field-label">Card holder</div>
                <div class="vc-field-value" id="vc-holder">— —</div>
              </div>
              <div>
                <div class="vc-field-label">Expires</div>
                <div class="vc-field-value">09 / 27</div>
              </div>
              <div class="vc-network">
                <div class="vc-circle-a"></div>
                <div class="vc-circle-b"></div>
              </div>
            </div>
          </div>

          <div class="card-actions" style="margin-bottom: 24px;">
            <button class="card-action-btn" onclick="showToast('Card number copied', 'success')">📋 Copy Number</button>
            <button class="card-action-btn" onclick="showToast('CVV revealed for 10 seconds', 'success')">👁️ Show CVV</button>
            <button class="card-action-btn" onclick="showToast('Card frozen', 'success')">🔒 Freeze</button>
            <button class="card-action-btn" onclick="showToast('Settings opened', 'success')">⚙️ Settings</button>
          </div>

          <div class="section-title">Recent Transactions</div>

          <div class="tx-list">
            <div class="tx-item">
              <div class="tx-icon shop">🛒</div>
              <div class="tx-info">
                <div class="tx-name">Online Marketplace</div>
                <div class="tx-date">Today, 10:34 AM</div>
              </div>
              <div class="tx-amount debit">-$48.99</div>
            </div>
            <div class="tx-item">
              <div class="tx-icon sub">🎬</div>
              <div class="tx-info">
                <div class="tx-name">Streaming Subscription</div>
                <div class="tx-date">Yesterday, 9:00 AM</div>
              </div>
              <div class="tx-amount debit">-$15.99</div>
            </div>
            <div class="tx-item">
              <div class="tx-icon transfer">💸</div>
              <div class="tx-info">
                <div class="tx-name">Card Top-Up</div>
                <div class="tx-date">Jun 24, 2:15 PM</div>
              </div>
              <div class="tx-amount credit">+$200.00</div>
            </div>
            <div class="tx-item">
              <div class="tx-icon travel">✈️</div>
              <div class="tx-info">
                <div class="tx-name">Flight Booking</div>
                <div class="tx-date">Jun 23, 6:47 PM</div>
              </div>
              <div class="tx-amount debit">-$312.00</div>
            </div>
            <div class="tx-item">
              <div class="tx-icon food">🍕</div>
              <div class="tx-info">
                <div class="tx-name">Food Delivery App</div>
                <div class="tx-date">Jun 22, 8:22 PM</div>
              </div>
              <div class="tx-amount debit">-$22.50</div>
            </div>
          </div>
        </div>

        <!-- Sidebar -->
        <div class="sidebar-panel">
          <div class="quick-actions">
            <div class="section-title">Quick Actions</div>
            <div class="action-grid">
              <div class="action-tile" onclick="showToast('Opening top-up flow…', 'success')">
                <div class="action-tile-icon">💰</div>
                <div class="action-tile-label">Top Up</div>
              </div>
              <div class="action-tile" onclick="switchSection('cards', document.querySelectorAll('.nav-item')[1])">
                <div class="action-tile-icon">➕</div>
                <div class="action-tile-label">New Card</div>
              </div>
              <div class="action-tile" onclick="showToast('Generating statement PDF…', 'success')">
                <div class="action-tile-icon">📄</div>
                <div class="action-tile-label">Statement</div>
              </div>
              <div class="action-tile" onclick="showToast('Support chat opened', 'success')">
                <div class="action-tile-icon">💬</div>
                <div class="action-tile-label">Support</div>
              </div>
            </div>
          </div>

          <div class="spend-card">
            <div class="section-title" style="margin-bottom: 0;">Spend by Category</div>
            <div class="spend-bar-row">
              <div class="spend-item">
                <div class="spend-label-row">
                  <span class="spend-label">🛒 Shopping</span>
                  <span class="spend-amount">$348</span>
                </div>
                <div class="spend-bar-bg">
                  <div class="spend-bar-fill" style="width: 68%; background: var(--plus-blue);"></div>
                </div>
              </div>
              <div class="spend-item">
                <div class="spend-label-row">
                  <span class="spend-label">✈️ Travel</span>
                  <span class="spend-amount">$312</span>
                </div>
                <div class="spend-bar-bg">
                  <div class="spend-bar-fill" style="width: 55%; background: var(--plus-cyan);"></div>
                </div>
              </div>
              <div class="spend-item">
                <div class="spend-label-row">
                  <span class="spend-label">🎬 Subscriptions</span>
                  <span class="spend-amount">$115</span>
                </div>
                <div class="spend-bar-bg">
                  <div class="spend-bar-fill" style="width: 32%; background: #8B5CF6;"></div>
                </div>
              </div>
              <div class="spend-item">
                <div class="spend-label-row">
                  <span class="spend-label">🍕 Food</span>
                  <span class="spend-amount">$72</span>
                </div>
                <div class="spend-bar-bg">
                  <div class="spend-bar-fill" style="width: 18%; background: var(--accent-amber);"></div>
                </div>
              </div>
            </div>
          </div>

          <div class="spend-card">
            <div class="section-title">Security Status</div>
            <div style="display: flex; flex-direction: column; gap: 12px;">
              <div style="display: flex; align-items: center; gap: 10px;">
                <div style="width: 8px; height: 8px; border-radius: 50%; background: var(--accent-green); flex-shrink: 0;"></div>
                <div style="font-size: 13px; color: var(--text-secondary);">2FA enabled</div>
              </div>
              <div style="display: flex; align-items: center; gap: 10px;">
                <div style="width: 8px; height: 8px; border-radius: 50%; background: var(--accent-green); flex-shrink: 0;"></div>
                <div style="font-size: 13px; color: var(--text-secondary);">Email verified</div>
              </div>
              <div style="display: flex; align-items: center; gap: 10px;">
                <div style="width: 8px; height: 8px; border-radius: 50%; background: var(--accent-amber); flex-shrink: 0;"></div>
                <div style="font-size: 13px; color: var(--text-secondary);">Phone pending verification</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- SECTION: Cards -->
    <div id="section-cards" class="dash-section">
      <div class="greeting">
        <h2>Your Cards</h2>
        <p>Manage, freeze, or create virtual cards</p>
      </div>

      <div class="cards-grid">
        <!-- Card 1 -->
        <div class="card-tile">
          <div class="card-tile-card blue">
            <div style="display: flex; justify-content: space-between;">
              <div style="font-family:'Space Grotesk',sans-serif; font-size:13px; font-weight:600; color:rgba(255,255,255,0.8);">PlusCard</div>
              <span class="badge active">Active</span>
            </div>
            <div style="font-family:'Space Grotesk',sans-serif; font-size: 14px; letter-spacing: 3px; color: rgba(255,255,255,0.85);">4291 •••• •••• 8823</div>
            <div style="font-size:11px; color:rgba(255,255,255,0.4); letter-spacing:1px;">PRIMARY / Expires 09/27</div>
          </div>
          <div class="card-tile-footer">
            <div>
              <div class="card-tile-name">Main Card</div>
              <div class="card-tile-limit">Limit: $5,000 / mo</div>
            </div>
            <button class="card-action-btn" onclick="showToast('Card settings opened', 'success')" style="flex: 0; padding: 8px 14px;">Manage</button>
          </div>
        </div>

        <!-- Card 2 -->
        <div class="card-tile">
          <div class="card-tile-card purple">
            <div style="display: flex; justify-content: space-between;">
              <div style="font-family:'Space Grotesk',sans-serif; font-size:13px; font-weight:600; color:rgba(255,255,255,0.8);">PlusCard</div>
              <span class="badge active">Active</span>
            </div>
            <div style="font-family:'Space Grotesk',sans-serif; font-size: 14px; letter-spacing: 3px; color: rgba(255,255,255,0.85);">7734 •••• •••• 2201</div>
            <div style="font-size:11px; color:rgba(255,255,255,0.4); letter-spacing:1px;">SUBSCRIPTIONS / Expires 03/26</div>
          </div>
          <div class="card-tile-footer">
            <div>
              <div class="card-tile-name">Subscriptions Card</div>
              <div class="card-tile-limit">Limit: $200 / mo</div>
            </div>
            <button class="card-action-btn" onclick="showToast('Card settings opened', 'success')" style="flex: 0; padding: 8px 14px;">Manage</button>
          </div>
        </div>

        <!-- Card 3 (frozen) -->
        <div class="card-tile">
          <div class="card-tile-card teal">
            <div style="display: flex; justify-content: space-between;">
              <div style="font-family:'Space Grotesk',sans-serif; font-size:13px; font-weight:600; color:rgba(255,255,255,0.8);">PlusCard</div>
              <span class="badge frozen">Frozen</span>
            </div>
            <div style="font-family:'Space Grotesk',sans-serif; font-size: 14px; letter-spacing: 3px; color: rgba(255,255,255,0.55);">9912 •••• •••• 5540</div>
            <div style="font-size:11px; color:rgba(255,255,255,0.3); letter-spacing:1px;">TRAVEL / Expires 12/26</div>
          </div>
          <div class="card-tile-footer">
            <div>
              <div class="card-tile-name">Travel Card</div>
              <div class="card-tile-limit">Limit: $1,000 / trip</div>
            </div>
            <button class="card-action-btn" onclick="showToast('Card unfrozen', 'success')" style="flex: 0; padding: 8px 14px;">Unfreeze</button>
          </div>
        </div>

        <!-- New card tile -->
        <div class="new-card-tile" onclick="showToast('Card creation wizard opening…', 'success')">
          <div class="new-card-icon">➕</div>
          <div class="new-card-label">Create a new card</div>
          <div style="font-size: 12px; color: var(--text-muted); text-align: center; max-width: 180px; line-height: 1.5;">Set a custom limit, label, and purpose</div>
        </div>
      </div>
    </div>

    <!-- SECTION: Transactions -->
    <div id="section-transactions" class="dash-section">
      <div class="greeting">
        <h2>Transactions</h2>
        <p>Your full payment history</p>
      </div>

      <div style="background: var(--card-bg); border: 1px solid var(--border); border-radius: 16px; padding: 24px;">
        <div style="display: flex; gap: 10px; margin-bottom: 20px; flex-wrap: wrap;">
          <input type="text" placeholder="🔍 Search transactions…" style="flex: 1; min-width: 200px;" />
          <select style="width: auto;">
            <option>All cards</option>
            <option>Main Card</option>
            <option>Subscriptions Card</option>
            <option>Travel Card</option>
          </select>
          <select style="width: auto;">
            <option>All types</option>
            <option>Debit</option>
            <option>Credit / Top-Up</option>
          </select>
        </div>

        <div class="tx-list">
          <div class="tx-item">
            <div class="tx-icon shop">🛒</div>
            <div class="tx-info">
              <div class="tx-name">Online Marketplace</div>
              <div class="tx-date">Jun 27 — Main Card · •••8823</div>
            </div>
            <div class="tx-amount debit">-$48.99</div>
          </div>
          <div class="tx-item">
            <div class="tx-icon sub">🎬</div>
            <div class="tx-info">
              <div class="tx-name">Streaming Subscription</div>
              <div class="tx-date">Jun 26 — Subs Card · •••2201</div>
            </div>
            <div class="tx-amount debit">-$15.99</div>
          </div>
          <div class="tx-item">
            <div class="tx-icon transfer">💸</div>
            <div class="tx-info">
              <div class="tx-name">Card Top-Up</div>
              <div class="tx-date">Jun 24 — Main Card · •••8823</div>
            </div>
            <div class="tx-amount credit">+$200.00</div>
          </div>
          <div class="tx-item">
            <div class="tx-icon travel">✈️</div>
            <div class="tx-info">
              <div class="tx-name">Flight Booking</div>
              <div class="tx-date">Jun 23 — Travel Card · •••5540</div>
            </div>
            <div class="tx-amount debit">-$312.00</div>
          </div>
          <div class="tx-item">
            <div class="tx-icon food">🍕</div>
            <div class="tx-info">
              <div class="tx-name">Food Delivery App</div>
              <div class="tx-date">Jun 22 — Main Card · •••8823</div>
            </div>
            <div class="tx-amount debit">-$22.50</div>
          </div>
          <div class="tx-item">
            <div class="tx-icon shop">🛒</div>
            <div class="tx-info">
              <div class="tx-name">Digital Product Store</div>
              <div class="tx-date">Jun 21 — Main Card · •••8823</div>
            </div>
            <div class="tx-amount debit">-$89.00</div>
          </div>
          <div class="tx-item">
            <div class="tx-icon transfer">💸</div>
            <div class="tx-info">
              <div class="tx-name">Card Top-Up</div>
              <div class="tx-date">Jun 20 — Subs Card · •••2201</div>
            </div>
            <div class="tx-amount credit">+$100.00</div>
          </div>
          <div class="tx-item">
            <div class="tx-icon sub">🎵</div>
            <div class="tx-info">
              <div class="tx-name">Music Streaming Plan</div>
              <div class="tx-date">Jun 20 — Subs Card · •••2201</div>
            </div>
            <div class="tx-amount debit">-$9.99</div>
          </div>
        </div>
      </div>
    </div>

    <!-- SECTION: Settings -->
    <div id="section-settings" class="dash-section">
      <div class="greeting">
        <h2>Settings</h2>
        <p>Manage your account and preferences</p>
      </div>

      <div class="settings-grid">
        <div class="settings-nav">
          <div class="settings-nav-item active" onclick="selectSettingsNav(this)">👤 Profile</div>
          <div class="settings-nav-item" onclick="selectSettingsNav(this)">🔐 Security</div>
          <div class="settings-nav-item" onclick="selectSettingsNav(this)">🔔 Notifications</div>
          <div class="settings-nav-item" onclick="selectSettingsNav(this)">💳 Billing</div>
          <div class="settings-nav-item" onclick="selectSettingsNav(this)">🌍 Preferences</div>
        </div>

        <div class="settings-panel">
          <div class="settings-section-title">Profile Information</div>

          <div class="form-row">
            <div class="form-group">
              <label>First name</label>
              <input type="text" id="s-fname" placeholder="First name" />
            </div>
            <div class="form-group">
              <label>Last name</label>
              <input type="text" id="s-lname" placeholder="Last name" />
            </div>
          </div>

          <div class="form-group">
            <label>Email address</label>
            <input type="email" id="s-email" placeholder="you@example.com" />
          </div>

          <div class="form-group">
            <label>Phone number</label>
            <input type="tel" id="s-phone" placeholder="+254 700 000 000" />
          </div>

          <button class="btn-primary" style="width: auto; padding: 12px 28px;" onclick="showToast('Profile saved successfully', 'success')">Save changes</button>

          <div style="margin-top: 32px;">
            <div class="settings-section-title">Notification Preferences</div>

            <div class="settings-row">
              <div class="settings-row-info">
                <h4>Transaction alerts</h4>
                <p>Get notified on every card transaction</p>
              </div>
              <label class="toggle">
                <input type="checkbox" checked />
                <div class="toggle-slider"></div>
              </label>
            </div>

            <div class="settings-row">
              <div class="settings-row-info">
                <h4>Low balance warnings</h4>
                <p>Alert when card balance drops below $50</p>
              </div>
              <label class="toggle">
                <input type="checkbox" checked />
                <div class="toggle-slider"></div>
              </label>
            </div>

            <div class="settings-row">
              <div class="settings-row-info">
                <h4>Security alerts</h4>
                <p>Notify on new logins and suspicious activity</p>
              </div>
              <label class="toggle">
                <input type="checkbox" checked />
                <div class="toggle-slider"></div>
              </label>
            </div>

            <div class="settings-row">
              <div class="settings-row-info">
                <h4>Marketing emails</h4>
                <p>Feature updates and promotions from PlusCard</p>
              </div>
              <label class="toggle">
                <input type="checkbox" />
                <div class="toggle-slider"></div>
              </label>
            </div>
          </div>

          <div style="margin-top: 32px; padding-top: 24px; border-top: 1px solid var(--border);">
            <div style="font-size: 14px; color: var(--error); cursor: pointer;" onclick="handleLogout()">⚠️ Sign out of all devices</div>
          </div>
        </div>
      </div>
    </div>

  </div>
</div>


<!-- ─── TOAST ─────────────────────────────────────────────── -->
<div class="toast" id="toast">
  <div class="toast-dot"></div>
  <span id="toast-msg">Done</span>
</div>


<script>
  // ── State ──────────────────────────────────────────────────
  let currentUser = null;

  // Demo credentials
  const DEMO = { email: 'demo@pluscard.com', password: 'demo1234' };

  // ── Navigation ─────────────────────────────────────────────
  function showPage(id) {
    document.querySelectorAll('.page').forEach(p => p.classList.remove('active'));
    document.getElementById(id).classList.add('active');
    window.scrollTo(0, 0);
  }

  function switchSection(name, el) {
    document.querySelectorAll('.dash-section').forEach(s => s.classList.remove('active'));
    document.getElementById('section-' + name).classList.add('active');
    document.querySelectorAll('.nav-item').forEach(n => n.classList.remove('active'));
    if (el) el.classList.add('active');
  }

  function selectSettingsNav(el) {
    document.querySelectorAll('.settings-nav-item').forEach(n => n.classList.remove('active'));
    el.classList.add('active');
  }

  // ── Auth ───────────────────────────────────────────────────
  function handleLogin() {
    const email = document.getElementById('login-email').value.trim();
    const pass  = document.getElementById('login-password').value;
    const errEl = document.getElementById('login-error');

    if (!email || !pass) { errEl.style.display = 'flex'; errEl.textContent = '⚠️ Please enter your email and password.'; return; }

    // Demo login OR any non-empty credentials
    currentUser = { firstName: 'Alex', lastName: 'Morgan', email };
    errEl.style.display = 'none';
    loadDashboard();
    showPage('page-dashboard');
  }

  function handleLogout() {
    currentUser = null;
    showPage('page-login');
    document.getElementById('login-email').value = '';
    document.getElementById('login-password').value = '';
  }

  // ── Register steps ─────────────────────────────────────────
  function regNextStep(step) {
    if (step === 1) {
      const fn = document.getElementById('reg-fname').value.trim();
      const ln = document.getElementById('reg-lname').value.trim();
      const em = document.getElementById('reg-email').value.trim();
      if (!fn || !ln || !em) { showToast('Please fill in all fields', 'error'); return; }
      if (!em.includes('@')) { showToast('Enter a valid email address', 'error'); return; }
    }

    if (step === 2) {
      const p1 = document.getElementById('reg-pass').value;
      const p2 = document.getElementById('reg-pass2').value;
      const mismatch = document.getElementById('pass-mismatch');
      if (p1.length < 8) { showToast('Password must be at least 8 characters', 'error'); return; }
      if (p1 !== p2) { mismatch.style.display = 'block'; return; }
      mismatch.style.display = 'none';
      const country = document.getElementById('reg-country').value;
      if (!country) { showToast('Please select your country', 'error'); return; }
    }

    document.getElementById('reg-step-' + step).classList.remove('active');
    document.getElementById('reg-step-' + (step + 1)).classList.add('active');
    updateStepDots(step + 1);
    if (step + 1 === 4) document.getElementById('reg-login-switch').style.display = 'none';
  }

  function regBackStep(step) {
    document.getElementById('reg-step-' + step).classList.remove('active');
    document.getElementById('reg-step-' + (step - 1)).classList.add('active');
    updateStepDots(step - 1);
  }

  function updateStepDots(active) {
    for (let i = 1; i <= 3; i++) {
      const dot = document.getElementById('dot-' + i);
      if (i < active) dot.className = 'step-dot done';
      else if (i === active) dot.className = 'step-dot active';
      else dot.className = 'step-dot inactive';
    }
  }

  function handleRegister() {
    const agreed = document.getElementById('terms-agree').checked;
    if (!agreed) { showToast('Please accept the Terms of Service', 'error'); return; }

    const fn = document.getElementById('reg-fname').value.trim();
    const ln = document.getElementById('reg-lname').value.trim();
    currentUser = { firstName: fn || 'New', lastName: ln || 'User', email: document.getElementById('reg-email').value.trim() };

    document.getElementById('reg-step-3').classList.remove('active');
    document.getElementById('reg-step-4').classList.add('active');
    document.getElementById('step-indicator').style.display = 'none';
    document.getElementById('reg-login-switch').style.display = 'none';
  }

  function goToDashboard() {
    loadDashboard();
    showPage('page-dashboard');
  }

  // ── Dashboard init ─────────────────────────────────────────
  function loadDashboard() {
    if (!currentUser) return;

    const fn = currentUser.firstName;
    const initials = (currentUser.firstName[0] + currentUser.lastName[0]).toUpperCase();
    const shortName = fn + ' ' + currentUser.lastName[0] + '.';

    document.getElementById('greeting-name').textContent = fn;
    document.getElementById('dash-avatar').textContent = initials;
    document.getElementById('dash-name').textContent = shortName;
    document.getElementById('vc-holder').textContent = (fn + ' ' + currentUser.lastName).toUpperCase();

    // Prefill settings
    document.getElementById('s-fname').value = currentUser.firstName;
    document.getElementById('s-lname').value = currentUser.lastName;
    document.getElementById('s-email').value = currentUser.email;

    // Date
    const now = new Date();
    document.getElementById('greeting-date').textContent = now.toLocaleDateString('en-US', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' });

    // Reset to overview
    switchSection('overview', document.querySelectorAll('.nav-item')[0]);
  }

  // ── Toast ──────────────────────────────────────────────────
  let toastTimer;
  function showToast(msg, type = 'success') {
    const t = document.getElementById('toast');
    const m = document.getElementById('toast-msg');
    clearTimeout(toastTimer);
    t.className = 'toast ' + type;
    m.textContent = msg;
    setTimeout(() => t.classList.add('show'), 10);
    toastTimer = setTimeout(() => t.classList.remove('show'), 3200);
  }

  // ── Allow enter key on login ────────────────────────────────
  document.getElementById('login-password').addEventListener('keydown', function(e) {
    if (e.key === 'Enter') handleLogin();
  });
</script>

</body>
</html>
