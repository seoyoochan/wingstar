# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# 관리자 계정의 생성 및 역할지정(관리자가 생성된 후 보안상의 이유로 비밀번호는 반드시 다른 것으로 변경하기 바람.)
# Devise의 :confirmable 모듈로 인한 본인 확인을 위한 이메일 발송 콜백을 피할려면 confirmed_at: Time.now 을 추가할 수 있다.

# encoding: UTF-8

admin_user = User.new(first_name: "유찬", last_name: "서", email: "admin@wingstar.net", password: "123123", locale: "ko", gender: "male", confirmed_at: Time.now, name: "서유찬", date_of_birth: "1992-01-05", username: "yoochan", website: "http://wingstar.net", profile_image: "http://s3.postimg.org/71048z72b/1234391_688020744559255_618503242_n.jpg", job: "Front-end Developer", description: "주로 액션영화를 즐겨보고 프로그래밍이나 축구로 시간을 보내는 평범한 개발자")
admin_user.save(validate: false)
admin_user.add_role :admin
profile = Profile.new(url: "http://wingstar.net/profile/#{admin_user.username}", user_id: "#{admin_user.id}")
profile.save(validate: false)
Blog.create(title: "서유찬", url: "http://wingstar.net/blog/#{admin_user.username}", user_id: "#{admin_user.id}", created_at: Time.now, updated_at: Time.now)
post1 = Post.create(title: "오늘의 명언", content: "\"고통이 고통이라는 이유로 그 자체를 사랑하고 소유하려는 자는 없다\"", user_id: admin_user.id, created_at: Time.now, blog_id: admin_user.blogs.first.id)
post2= Post.create(title: "About Weather!", content: "wonderful serenity has taken possession of my entire soul, like these sweet mornings of spring which I enjoy with my whole heart.
I am alone, and feel the charm of existence in this spot, which was created for the bliss of souls
like mine. I am so happy, my dear friend, so absorbed in the exquisite sense of mere tranquil existence,
that I neglect my talents. I should be incapable of drawing a single stroke at the present moment;
and yet I feel that I never was a greater artist than now. When, while the lovely valley teems with
vapour around me, and the meridian sun strikes the upper surface of the impenetrable foliage of my trees,
and but a few stray gleams steal into the inner sanctuary, I throw myself down among the tall grass
by the trickling stream; and, as I lie close to the earth, a thousand unknown plants are noticed by me:
when I hear the buzz of the little world among the stalks, and grow familiar with the countless indescribable
forms of the insects and flies, then I feel the presence of the Almighty, who formed us in his own image,
and the breath", user_id: admin_user.id, created_at: Time.now, blog_id: admin_user.blogs.first.id)

post1.tag_list.add("명언","인문학","아름다운 글")
post2.tag_list.add("weather","날씨","영어","장문")
post1.save(validate: false)
post2.save(validate: false)

user01 = User.new(first_name: "길동", last_name: "홍", email: "gildong@wingstar.net", password: "123123", locale: "ko", gender: "male", confirmed_at: Time.now, name: "홍길동", date_of_birth: "1992-01-05", username: "gildong" )
user01.save(validate: false)
profile = Profile.new(url: "http://wingstar.net/profile/#{user01.username}", user_id: "#{user01.id}")
profile.save(validate: false)


user02 = User.new(first_name: "Carroll", last_name: "Alison", email: "carroll@wingstar.net", password: "123123", locale: "en", gender: "female", confirmed_at: Time.now, name: "Alison Carroll", date_of_birth: "1987-12-05", username: "alison" )
user02.save(validate: false)
profile = Profile.new(url: "http://wingstar.net/profile/#{user02.username}", user_id: "#{user02.id}")
profile.save(validate: false)


