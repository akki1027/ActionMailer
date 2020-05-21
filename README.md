# 新たなユーザーアカウントが作成された際に、メールを送信する。


# 必要なgem
パスワードなどをGitHubに載せないよう.envにメールのパスワードなどを記載するため。
```bash
gem 'dotenv-rails'
```
そして、
```bash
$ bundle install
```
を行う。  
ついでに、.envファイルをアプリケーション直下に作成し、.gitignoreに以下を追加してください。  
.gitignore
```bash
.env
```


# Deviseのインストール
ユーザーアカウントの作成機能が必要なため、deviseをインストールし、設定をしてください。  
deviseのインストール・設定の仕方に関しては、今回は省略させていただきます。


# 最後にActionMailerを作成。
```bash
$ rails g mailer WelcomeMailer
```
* app/mailers/welcome_mailer.rb  
* app/views/welcome_mailer  
* test/mailers/welcome_mailer_test.rb  
* test/mailers/previews/welcome_mailer_preview.rb  
が作成されます。

#### 先ほど作成された、app/mailers/welcome_mailer.rbにメールの送信機能を実装するために追記をしていきます。
app/mailers/welcome_mailer.rb
```bash
def welcome_mail(user)
	@user = user
	@url = "http://localhost:3000/users/#{user.id}"
	mail(
		subject: "会員登録が完了しました。",
		to: @user.email
	)
end
```

#### さらに、先ほどもう一つ作成されたapp/views/welcome_mailerに、welcome_mail.text.erbという名前でファイルを作成してください。
メール本文のレイアウトを作成します。  
app/views/welcome_mailer/welcome_mail.text.erb
```bash
会員登録が完了しました。

以下のURLからマイページへアクセスしてください。
<%= user_url(@user) %>
```


# メールサーバーの設定。
config/environments/development.rbに以下を追記する(ファイル内ならどこに追記してもよいが、以下の場所あたりが分かりやすいかも)。  
config/environments/development.rb
```bash
config.action_mailer.perform_caching = false

# ------------------追記-----------------
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    address: 'smtp.gmail.com',
    domain: 'gmail.com',
    port: 587,
    user_name: ENV['EMAIL'],
    password:  ENV['PASSWORD'],
    authentication: 'plain',
    enable_starttls_auto: true
  }

  config.action_mailer.default_url_options = { host: "localhost:3000"}
# ----------------追記ここまで-------------

# Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log
```


# .envファイルに、メールアドレスとパスワードを追記。
EMAILには、メールサーバーとして利用したいメールアドレスを記入してください。  
PASSWORDには、メールサーバーとして利用するメールアカウントのパスワードを記入してください。  
.env
```bash
EMAIL="example@example"
PASSWORD="example"
```


# 最後に、ユーザーアカウントが作成されたタイミングでメールを送信する設定を行います。
deviseのコントローラーを編集するので、deviseのコントローラーを作成してください。
```bash
$ rails g devise:controllers users
```

作成したら、app/controllers/users/registrations_controller.rbに追記をします。  
createアクションがコメントアウトされているので、コメントアウトを解除してから、以下の追記をしてください。  
app/controllers/users/registrations_controller.rb
```bash
def create
	super
	# -----------------------追記----------------------
	if @user.save
	  WelcomeMailer.welcome_mail(@user).deliver_later
	end
	# ---------------------追記ここまで------------------
end
```

deviseのregistrationsコントローラーを変更したので、config/routes.rbのdeviseを以下のように編集する必要があります。
config/routes.rb
```bash
devise_for :users, controllers: {
	registrations: 'users/registrations'
}
```

以上で、全ての設定が完了です。  
http://localhost:3000/users/sign_up  
にアクセスして、ユーザーの新規登録を行なってみてください。  
ユーザーを作成する際に登録したメールアドレスに、メールが届くはずです。
