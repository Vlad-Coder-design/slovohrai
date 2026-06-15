# Підключення Google та Supabase

## 1. Створіть проєкт Supabase

1. Відкрийте https://supabase.com/dashboard і натисніть **New project**.
2. Вкажіть назву, пароль бази та найближчий регіон.
3. Відкрийте **SQL Editor**, створіть новий запит.
4. Вставте весь вміст файлу `supabase/setup.sql` та натисніть **Run**.

## 2. Додайте ключі до застосунку

1. У Supabase відкрийте **Project Settings -> API**.
2. Скопіюйте **Project URL** і **Publishable key**.
3. Вставте їх у файл `supabase-config.js`.
4. Не використовуйте в браузері `service_role` або secret key.

## 3. Налаштуйте Google

1. У Supabase відкрийте **Authentication -> Providers -> Google**.
2. Скопіюйте показаний там **Callback URL**. Він має вигляд
   `https://PROJECT.supabase.co/auth/v1/callback`.
3. Відкрийте https://console.cloud.google.com/ та створіть проєкт.
4. У **Google Auth Platform** заповніть **Branding** і **Audience**.
5. Для тестування додайте свою Google-пошту до **Test users**.
6. У **Data Access** додайте `openid`, `userinfo.email` і `userinfo.profile`.
7. У **Clients** створіть **OAuth client ID -> Web application**.
8. До **Authorized JavaScript origins** додайте адресу опублікованого сайту.
9. До **Authorized redirect URIs** вставте Callback URL із Supabase.
10. Скопіюйте Google **Client ID** і **Client Secret** у налаштування
    Google-провайдера в Supabase та увімкніть його.

## 4. Додайте адресу сайту

Google-вхід не працюватиме при відкритті через `file:///`.

1. Опублікуйте цю папку на Netlify, Vercel або GitHub Pages.
2. У Supabase відкрийте **Authentication -> URL Configuration**.
3. Вкажіть адресу сайту в **Site URL**.
4. Додайте цю саму адресу в **Redirect URLs**.

Після цього відкрийте опублікований сайт і натисніть **Увійти**.
