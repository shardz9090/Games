extends PanelContainer

const FOLLOW_US_ARRAY: Array = [
	{
		"Name": "Facebook",
		"Link": "https://www.facebook.com/TeslatechNepal?mibextid=ZbWKwL"
	},
	{
		"Name": "Linkedin",
		"Link": "https://np.linkedin.com/company/teslatech-nepal"
	},
	{
		"Name": "Youtube",
		"Link": "https://www.youtube.com/channel/UCrCNYLrHCLXy2W2Y7-HOfCQ"
	},
]
const JOIN_US: Array = [
	{
		"Name": "Careers at Teslatech",
		"Link": "https://teslatech.com.np/careers/"
	}
]
const OFFICE_INFO: Array = [
	{
		"Name": "Dhobighat, Lalitpur, Nepal",
		"Link": "https://www.google.com/maps/place/Teslatech,+Lalitpur+44700/data=!4m2!3m1!1s0x39eb19b5e8ce351d:0x361fc4a798978757?utm_source=mstt_1&entry=gps"
	},
	{
		"Name": "hello@teslatech.com.np",
		"Link": "mailto:hello@teslatech.com.np"
	}
]

export(PackedScene) var game_link_button

onready var _products_v_box: VBoxContainer = $MarginContainer/ContentVBox/MainHBox/ProductsVBox
onready var _follow_us_v_box: VBoxContainer = $MarginContainer/ContentVBox/MainHBox/FollowUsVBox
onready var _join_us_v_box: VBoxContainer = $MarginContainer/ContentVBox/MainHBox/JoinUsVBox
onready var _office_info_v_box = $MarginContainer/ContentVBox/MainHBox/OfficeInfoVBox


func _ready() -> void:
	var m_link_button_instance: Object
	
	_spawn_link_buttons(m_link_button_instance, GlobalStore.game_names, _products_v_box)
	_spawn_link_buttons(m_link_button_instance, FOLLOW_US_ARRAY, _follow_us_v_box)
	_spawn_link_buttons(m_link_button_instance, JOIN_US, _join_us_v_box)
	_spawn_link_buttons(m_link_button_instance, OFFICE_INFO, _office_info_v_box)


func _spawn_link_buttons(p_link_button_instance, p_array, p_v_box) -> void:
	for i in range(p_array.size()):
		p_link_button_instance = game_link_button.instance()
		p_link_button_instance.text = p_array[i]["Name"]
		p_link_button_instance.button_link = p_array[i]["Link"]
		p_v_box.add_child(p_link_button_instance)
