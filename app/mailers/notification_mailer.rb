class NotificationMailer < ApplicationMailer
	default from: 'no-replay@gmail.com'

	def complete_mail(user)
		@user = user
		@url = "http://localhost:3000/users/#{user.id}"
		mail(
			subject: "会員登録が完了しました。",
			to: @user.email
		)
	end
	# def send_confirm_to_user(user)
	#     @user = user
	#     mail(
	#       subject: "会員登録が完了しました。", #メールのタイトル
	#       to: @user.email #宛先
	#     ) do |format|
	#       format.text
 #    end
end
