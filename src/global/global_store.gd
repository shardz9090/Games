extends Node

enum Side {
	LEFT,
	RIGHT
}
const GAME_PICTURES: Array = [
	"res://assets/images/callbreak-3.png",
	"res://assets/images/ludo.png",
	"res://assets/images/sabda_paheli.png"
]

const GAME_NAMES: Array = [
	{
		"Name": "Callbreak.com – Card game",
		"Description": "Who doesn’t love a fun and exciting card game that’s easy to learn and can also be enjoyed with a group of family and friends? Look no further than Callbreak: Game of Cards – the mega-hit card game that has taken the Play Store by storm!",
		"PlayStore": true,
		"AppStore": true,
		"Website": true,
		"Image": "res://assets/images/callbreak-3.png",
		"Logo": "res://assets/images/logos/callbreak_logo.webp",
		"Link": "https://teslatech.com.np/product/callbreak-game-of-cards/"
	},
	{
		"Name": "Callbreak Lite",
		"Description": "Callbreak lite brings classic and popular mega hit card game- Callbreak with online multiplayer feature to the Google Play Store. This is the same game that reached 100 million downloads, which has been re-released in a lighter version due to popular demand. Low storage phone? No problem! Download this Lite version of Callbreak for faster […]",
		"PlayStore": true,
		"AppStore": false,
		"Website": true,
		"Image": "res://assets/images/callbreak-lite_image.png",
		"Logo": "res://assets/images/logos/callbreak-lite_logo.webp",
		"Link": "https://teslatech.com.np/product/callbreak-lite/"
	},
	{
		"Name": "Ludo Life: Multiplayer Raja",
		"Description": "Now with Ludo Life: Multiplayer Raja enjoy an AD-FREE journey! Absolutely zero ads for a seamless experience. Fun multiplayer strategic & competitive board game played between 2 – 4 players. Of all the games for free, Ludo Life is the one- which being a four player game provides you and your friends the maximum fun! […]",
		"PlayStore": true,
		"AppStore": true,
		"Website": true,
		"Image": "res://assets/images/ludo.png",
		"Logo": "res://assets/images/logos/ludo_logo.webp",
		"Link": "https://teslatech.com.np/product/ludo-life-multiplayer-raja/"
	},
	{
		"Name": "Shabda Paheli – नेपाली",
		"Description": "Shabda Paheli is a Nepali word puzzle game.",
		"PlayStore": true,
		"AppStore": false,
		"Website": false,
		"Image": "res://assets/images/sabda_paheli.png",
		"Logo": "res://assets/images/logos/sabdhapaheli-icon_logo.png",
		"Link": "https://teslatech.com.np/product/shabda-paheli-%e0%a4%a8%e0%a5%87%e0%a4%aa%e0%a4%be%e0%a4%b2%e0%a5%80/"
	},
]

const TEAM_MEMBERS: Array = [
	{"name": "Sujan Shakya", "post": "FOUNDER & CEO"},
	{"name": "Anuj Shankar Shrestha", "post": "COO"},
	{"name": "Praveen Shrestha", "post": "PRODUCT MANAGER"},
	{"name": "Mahesh Khanal", "post": "ENGINEERING MANAGER"},
	{"name": "Manish Shakya", "post": "MANAGER – DATA ANALYST"},
	{"name": "Nabin Bogati", "post": "LEAD BACKEND DEVELOPER"},
	{"name": "Rabina Bhujel", "post": "ASSISTANT MANAGER – HR"},
	{"name": "Sangita Tamang", "post": "ASSISTANT MANAGER – SALES AND MARKETING"},
	{"name": "Upendra Bikram Thapa", "post": "LEAD QA"},
	{"name": "Jenish Shakya", "post": "GAME DEVELOPER - ANDROID"},
	{"name": "Aashutosh Shrestha", "post": "GAME DEVELOPER - IOS"},
	{"name": "Rusum Shrestha", "post": "UI/UX"},
	{"name": "Ankit Raya", "post": "GAME DEVELOPER"},
	{"name": "Ajit Bhattarai", "post": "GAME DEVELOPER - JAVASCRIPT"},
	{"name": "Nabin Thapa", "post": "BACKEND DEVELOPER"},
	{"name": "Arun Bikram Khatri", "post": "GAME DEVELOPER"},
	{"name": "Ashwin Belbase", "post": "DEVOPS"},
	{"name": "Nyushan Darshandhari", "post": "GAME DEVELOPER"},
	{"name": "Puskar Adhikari", "post": "GAME DEVELOPER"},
	{"name": "Rojan Manandhar", "post": "GAME DEVELOPER"},
	{"name": "Ronak Agrawal", "post": "FINANCIAL ANALYST"},
	{"name": "Samar Shrestha", "post": "AI DEVELOPER"},
	{"name": "Samrat Singh", "post": "GAME DEVELOPER"},
	{"name": "Sandeep Ghimire", "post": "BACKEND DEVELOPER"},
	{"name": "Showan Rai", "post": "GAME ARTIST"},
	{"name": "Sudip Tamang", "post": "GAME DEVELOPER"},
	{"name": "Sumanta Paudel", "post": "GAME DEVELOPER"},
	{"name": "Yuyutsu Poudel", "post": "GAME DEVELOPER"},
	{"name": "Rohan Kaju", "post": "GAME DEVELOPER"},
	{"name": "Shardul Mishra", "post": "GAME DEVELOPER INTERN"},
	{"name": "Anish Upadhyay", "post": "QA INTERN"},
	{"name": "Sushank Shrestha", "post": "ASSOCIATE PRODUCT STRATEGIST"},
	{"name": "Manisha Shrestha", "post": "UX DESIGNER"},
	{"name": "Anil Kumar Thapa", "post": "MANAGEMENT INTERN"},
	{"name": "Lalu Maya Sherpa", "post": "SUPPORT STAFF"},
	{"name": "Rita Karki", "post": "SUPPORT STAFF"},
	{"name": "Menuka Khadka Thapa", "post": "SUPPORT STAFF"}
]

const PARTNERS_LOGOS: Array = [
	{
		"name": "ChocolatePlatform",
		"logo": "res://assets/images/logos/partners/chocolateplatform.png",
	},
	{
		"name": "gg",
		"logo": "res://assets/images/logos/partners/gg.png",
	},
	{
		"name": "google-ad-mob",
		"logo": "res://assets/images/logos/partners/google-ad-mob.png",
	},
	{
		"name": "index",
		"logo": "res://assets/images/logos/partners/index.png",
	},
	{
		"name": "inmobi",
		"logo": "res://assets/images/logos/partners/inmobi.png",
	},
	{
		"name": "liftoff",
		"logo": "res://assets/images/logos/partners/liftoff.png",
	},
	{
		"name": "pangle",
		"logo": "res://assets/images/logos/partners/pangle.png",
	},
	{
		"name": "smaato",
		"logo": "res://assets/images/logos/partners/smaato.png",
	},
	{
		"name": "unity",
		"logo": "res://assets/images/logos/partners/unity.png",
	},
]

const ACHIEVEMENT_DATES: Array = [
	{
	"date": "2014/11/02",
	"event": "Released Callbreak Multiplayer 0.0.1"
	},
	{
	"date": "2015/04/13",
	"event": "Registered as Tesla Tech"
	},
	{
	"date": "2017/03/17",
	"event": "Reached 5M Callbreak Multiplayer downloads on Google Play Store"
	},
	{
	"date": "2017/04/04",
	"event": "Registered as Teslatech Private Limited"
	},
	{
	"date": "2017/09/15",
	"event": "Reached 10M Callbreak Multiplayer downloads on Google Play Store"
	},
	{
	"date": "2019/06/15",
	"event": "Reached 50M Callbreak Multiplayer downloads on Google Play Store"
	},
	{
	"date": "2020/11/08",
	"event": "Released ShabdaPaheli"
	},
	{
	"date": "2022/08/11",
	"event": "Reached 100M Callbreak Multiplayer downloads on Google Play Store"
	},
	{
	"date": "2022/10/01",
	"event": "Launched LUDO LIFE in Play store and App Store"
	}
]

var game_names: Array
