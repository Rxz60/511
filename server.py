<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TRX Obfuscator</title>
    <link href="https://fonts.googleapis.com/css2?family=Tajawal:wght@400;500;700;800&family=Fira+Code:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-color: #030206;
            --card-bg: rgba(22, 18, 28, 0.75);
            --card-border: #2e1d42;
            --editor-bg: #09070d;
            --editor-border: #1e162d;
            --primary-purple: #a82bf0;
            --purple-glow: rgba(168, 43, 240, 0.45);
            --btn-purple: #8125cf;
            --badge-bg: rgba(74, 21, 122, 0.5);
            --text-main: #ffffff;
            --text-muted: #8b8599;
            --pink-accent: #f282e8;
            --grid-color: rgba(168, 43, 240, 0.07);
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Tajawal', sans-serif;
        }

        body {
            background-color: var(--bg-color);
            color: var(--text-main);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            padding: 30px 15px;
            position: relative;
            overflow-x: hidden;
            background-image: 
                radial-gradient(circle at 50% 0%, #2a084c 0%, transparent 60%),
                linear-gradient(var(--grid-color) 1px, transparent 1px),
                linear-gradient(90deg, var(--grid-color) 1px, transparent 1px);
            background-size: 100% 100%, 28px 28px, 28px 28px;
            background-position: center center, center center, center center;
        }

        body::before {
            content: '';
            position: absolute;
            top: -100px;
            left: 50%;
            transform: translateX(-50%);
            width: 400px;
            height: 400px;
            background: radial-gradient(circle, rgba(168, 43, 240, 0.25) 0%, transparent 70%);
            pointer-events: none;
            z-index: 0;
        }

        .container {
            width: 100%;
            max-width: 460px;
            display: flex;
            flex-direction: column;
            gap: 22px;
            position: relative;
            z-index: 1;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 5px 0;
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .logo-box {
            width: 52px;
            height: 52px;
            background: #090510;
            border: 1px solid rgba(168, 43, 240, 0.4);
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 0 20px var(--purple-glow), inset 0 0 10px rgba(168, 43, 240, 0.2);
            position: relative;
            overflow: hidden;
        }

        .logo-box svg {
            width: 32px;
            height: 32px;
            filter: drop-shadow(0 0 6px #d92be3) drop-shadow(0 0 12px #a82bf0);
        }

        .title-area h1 {
            font-size: 19px;
            font-weight: 800;
            line-height: 1.2;
            letter-spacing: 0.5px;
        }

        .title-area p {
            font-size: 12px;
            color: var(--text-muted);
        }

        .by-tag {
            font-size: 13px;
            color: var(--text-muted);
            font-weight: 500;
        }

        .hero {
            text-align: center;
            display: flex;
            flex-direction: column;
            align-items: center;
            margin: 5px 0;
        }

        .hero h2 {
            font-size: 34px;
            font-weight: 800;
            background: linear-gradient(180deg, #ffffff 20%, #f282e8 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 10px;
            letter-spacing: -0.5px;
        }

        .hero p {
            font-size: 13px;
            color: var(--text-muted);
            line-height: 1.6;
            margin-bottom: 18px;
            font-weight: 400;
        }

        .pill-badge {
            border: 1px solid rgba(168, 43, 240, 0.5);
            background: rgba(35, 12, 54, 0.6);
            color: #e2b3ff;
            padding: 7px 22px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            box-shadow: 0 0 12px rgba(168, 43, 240, 0.15);
            backdrop-filter: blur(8px);
        }

        .card {
            background: var(--card-bg);
            border: 1px solid var(--card-border);
            border-radius: 18px;
            padding: 18px;
            backdrop-filter: blur(14px);
            display: flex;
            flex-direction: column;
            gap: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
        }

        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .card-title {
            font-size: 15px;
            font-weight: 700;
        }

        .btn-small {
            background: var(--badge-bg);
            color: #d19eff;
            border: 1px solid rgba(168, 43, 240, 0.3);
            padding: 6px 16px;
            border-radius: 10px;
            font-size: 12px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .btn-small:hover {
            background: rgba(129, 37, 207, 0.7);
            color: #fff;
            box-shadow: 0 0 10px var(--purple-glow);
        }

        .btn-group {
            display: flex;
            gap: 8px;
        }

        .editor-wrapper {
            position: relative;
            width: 100%;
        }

        textarea {
            width: 100%;
            height: 200px;
            background: var(--editor-bg);
            border: 1px solid var(--editor-border);
            border-radius: 12px;
            padding: 14px;
            font-family: 'Fira Code', monospace;
            font-size: 12px;
            color: #e0e0e0;
            line-height: 1.6;
            resize: none;
            outline: none;
            direction: ltr;
            text-align: left;
            transition: border-color 0.2s;
        }

        textarea:focus {
            border-color: rgba(168, 43, 240, 0.6);
            box-shadow: inset 0 0 8px rgba(168, 43, 240, 0.2);
        }

        textarea::placeholder {
            color: #4a4458;
            font-family: 'Tajawal', sans-serif;
            direction: rtl;
            text-align: right;
        }

        .file-size {
            font-size: 12px;
            color: var(--text-muted);
            direction: ltr;
            text-align: right;
            font-weight: 500;
        }

        .btn-submit {
            width: 100%;
            background: linear-gradient(90deg, #9b26dc, #d92be3);
            color: #fff;
            border: none;
            padding: 16px;
            border-radius: 14px;
            font-size: 16px;
            font-weight: 800;
            cursor: pointer;
            box-shadow: 0 6px 25px var(--purple-glow);
            transition: transform 0.15s ease, box-shadow 0.15s ease;
        }

        .btn-submit:hover {
            transform: translateY(-1px);
            box-shadow: 0 8px 30px rgba(168, 43, 240, 0.65);
        }

        .btn-submit:active {
            transform: translateY(1px);
        }

        .toast {
            position: fixed;
            bottom: 25px;
            left: 50%;
            transform: translateX(-50%) translateY(100px);
            background: #1e112e;
            color: #f282e8;
            border: 1px solid var(--primary-purple);
            padding: 10px 24px;
            border-radius: 30px;
            font-size: 13px;
            font-weight: 600;
            box-shadow: 0 5px 20px rgba(0,0,0,0.8);
            opacity: 0;
            transition: all 0.3s ease;
            z-index: 1000;
            pointer-events: none;
        }

        .toast.show {
            transform: translateX(-50%) translateY(0);
            opacity: 1;
        }

        #fileInput {
            display: none;
        }
    </style>
</head>
<body>

    <div class="container">
        <header class="header">
            <div class="brand">
                <div class="logo-box">
                    <svg viewBox="0 0 100 100" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M50 12 L90 82 L10 82 Z" stroke="#e040ff" stroke-width="7" stroke-linejoin="round" />
                        <path d="M50 32 L75 75 L35 75" stroke="#a82bf0" stroke-width="6" stroke-linecap="round" stroke-linejoin="round" />
                        <path d="M42 52 L62 52 L50 72" stroke="#f282e8" stroke-width="5" stroke-linecap="round" stroke-linejoin="round" />
                    </svg>
                </div>
                <div class="title-area">
                    <h1>TRX Obfuscator</h1>
                    <p>Lua Protection</p>
                </div>
            </div>
            <div class="by-tag">by TRX</div>
        </header>

        <section class="hero">
            <h2>شفر سكريبتاتك بقوة</h2>
            <p>حماية متقدمة بمفاتيح مدمجة • تصميم TRX</p>
            <div class="pill-badge">TRX تم التشفير بواسطة</div>
        </section>

        <div class="card">
            <div class="card-header">
                <span class="card-title">السكريبت الأصلي</span>
                <label for="fileInput" class="btn-small">lua. رفع ملف</label>
                <input type="file" id="fileInput" accept=".lua,.txt">
            </div>
            <div class="editor-wrapper">
                <textarea id="inputCode" placeholder="هنا الصق سكريبت Lua"></textarea>
            </div>
            <div class="file-size" id="inputSize">KB الحجم: 0.00</div>
        </div>

        <div class="card">
            <div class="card-header">
                <span class="card-title">النتيجة المشفرة</span>
                <div class="btn-group">
                    <button class="btn-small" id="downloadBtn">تحميل</button>
                    <button class="btn-small" id="copyBtn">نسخ</button>
                </div>
            </div>
            <div class="editor-wrapper">
                <textarea id="outputCode" readonly placeholder="ستظهر النتيجة هنا"></textarea>
            </div>
            <div class="file-size" id="outputSize">KB الحجم: 0.00</div>
        </div>

        <button class="btn-submit" id="obfuscateBtn">تشفير السكريبت</button>
    </div>

    <div class="toast" id="toast">تم النسخ بنجاح!</div>

    <script>
        const inputCode = document.getElementById('inputCode');
        const outputCode = document.getElementById('outputCode');
        const inputSize = document.getElementById('inputSize');
        const outputSize = document.getElementById('outputSize');
        const fileInput = document.getElementById('fileInput');
        const copyBtn = document.getElementById('copyBtn');
        const downloadBtn = document.getElementById('downloadBtn');
        const obfuscateBtn = document.getElementById('obfuscateBtn');
        const toast = document.getElementById('toast');

        const SITE_SECRET_KEYS = [
            "hndr_19c7cb11f032a369389d2e0e0cea58b41c80",
            "wgpt_5b117a74f34317dd35ef91b5d6cdd4167440c80fcffd92a7",
            "SecretKeyThree",
            "SecretKeyFour",
            "SecretKeyFive",
            "SecretKeySix"
        ];

        function calculateKB(text) {
            const bytes = new Blob([text]).size;
            return (bytes / 1024).toFixed(2);
        }

        function updateSizes() {
            inputSize.textContent = "KB الحجم: " + calculateKB(inputCode.value);
            outputSize.textContent = "KB الحجم: " + calculateKB(outputCode.value);
        }

        function showToast(message) {
            toast.textContent = message;
            toast.classList.add('show');
            setTimeout(() => {
                toast.classList.remove('show');
            }, 2000);
        }

        inputCode.addEventListener('input', updateSizes);

        fileInput.addEventListener('change', (e) => {
            const file = e.target.files[0];
            if (!file) return;

            const reader = new FileReader();
            reader.onload = (event) => {
                inputCode.value = event.target.result;
                updateSizes();
                showToast('تم تحميل الملف بنجاح');
            };
            reader.readAsText(file);
        });

        copyBtn.addEventListener('click', () => {
            if (!outputCode.value) {
                showToast('لا يوجد كود لنسخه');
                return;
            }

            outputCode.select();
            document.execCommand('copy');
            showToast('تم النسخ إلى الحافظة!');
        });

        downloadBtn.addEventListener('click', () => {
            if (!outputCode.value) {
                showToast('لا يوجد كود لتحميله');
                return;
            }
            const blob = new Blob([outputCode.value], { type: 'text/plain;charset=utf-8' });
            const url = URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = 'TRX_Obfuscated.lua';
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
            URL.revokeObjectURL(url);
            showToast('جاري تحميل الملف...');
        });

        function stringToSeed(str) {
            let hash = 0;
            for (let i = 0; i < str.length; i++) {
                hash = ((hash << 5) - hash) + str.charCodeAt(i);
                hash |= 0;
            }
            return Math.abs(hash);
        }

        function obfuscateLuaWithSiteKeys(source) {
            if (!source.trim()) return '';

            const clean = source.trim();
            let parsedKeys = SITE_SECRET_KEYS.map(k => (stringToSeed(k) % 239) + 10);

            let bytes = [];
            for (let i = 0; i < clean.length; i++) {
                let b = clean.charCodeAt(i);
                for (let k = 0; k < parsedKeys.length; k++) {
                    b = (b ^ parsedKeys[k]) + (k + 3);
                    b = b % 256;
                }
                bytes.push(b);
            }

            const a = "t" + Math.random().toString(36).slice(2, 9);
            const d = "s" + Math.random().toString(36).slice(2, 9);
            const c = "i" + Math.random().toString(36).slice(2, 9);
            const data = bytes.join(",");

            return 'local keys = {' + parsedKeys.join(", ") + '}\n' +
                   'local ' + a + ' = {' + data + '}\n' +
                   'local ' + d + ' = ""\n' +
                   'for ' + c + ' = 1, #' + a + ' do\n' +
                   '    local b = ' + a + '[' + c + ']\n' +
                   '    for k = #keys, 1, -1 do\n' +
                   '        b = (b - (k + 3))\n' +
                   '        if b < 0 then b = b + 256 end\n' +
                   '        b = (b ~ keys[k]) % 256\n' +
                   '    end\n' +
                   '    ' + d + ' = ' + d + ' .. string.char(b)\n' +
                   'end\n' +
                   'local f = (loadstring or load)\n' +
                   'return f(' + d + ')()';
        }

        obfuscateBtn.addEventListener('click', () => {
            const source = inputCode.value;
            if (!source.trim()) {
                showToast('يرجى كتابة أو رفع سكريبت أولاً');
                return;
            }

            const result = obfuscateLuaWithSiteKeys(source);
            outputCode.value = result;
            updateSizes();
            showToast('تم تشفير السكريبت بنجاح!');
        });
    </script>
</body>
</html>
