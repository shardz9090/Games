extends Node

signal card_migrated(p_card, p_row)
signal card_moved(p_last_column, p_new_column)

const SCORE_IN_SUIT = 20
const COLUMNS: int = 7
const ROWS: int = 8
const SUIT_COLUMN: int = 10
const DEAL_COLUMN: int = 15

var level: int
var playing_column_size: int = COLUMNS * (COLUMNS + 1) / 2
var lowest_card_rank_clubs: int = 1
var lowest_card_rank_hearts: int = 1
var lowest_card_rank_diamonds: int = 1
var lowest_card_rank_spades: int = 1

var all_cards: Array = []
var card_column_array: Array = [[],[],[],[],[],[],[],[]]
var deal_deck_array: Array = []
var i_in_deal: int = 0

var spades_suit_array: Array = []
var diamonds_suit_array: Array = []
var hearts_suit_array: Array = []
var clubs_suit_array: Array = []

var take_mouse_in: bool = true
var latest_move: Array
var face_up_overlapping_bodies: Array = []
var playing_deal_deck: Array = []
var suit_card_array: Array = []
var touched_cards: Array = []
var moved_card_details: Array
var disabled_cards: Array = []
var face_down_card: Object


enum sound_status {
	ON,
	OFF
}

enum card_no_face_rank {
	ACE = 1,
	TWO,
	THREE,
	FOUR,
	FIVE,
	SIX,
	SEVEN,
	EIGHT,
	NINE,
	TEN,
	JACK,
	QUEEN,
	KING
}

enum card_symbol {
	SPADE = 1,
	HEARTS,
	CLUBS,
	DIAMOND
}

enum card_color {
	RED = 1,
	BLACK
}

enum card_face_side {
	UP = 1,
	DOWN
}

enum game_level {
	EASY = 1,
	HARD
}

enum card_last_move {
	DEAL_DECK_TO_PLAYING_DEAL_DECK = 30,
	COLUMN_TO_COLUMN,
	COLUMN_TO_SUIT,
	SUIT_TO_COLUMN,
	PLAYING_DEAL_DECK_TO_COLUMN,
	EMPTY_DEAL_DECK,
	KING_TO_EMPTY_AREA,
}

var rank_dict: Dictionary = {
	card_no_face_rank.ACE: "ace",
	card_no_face_rank.TWO: "2",
	card_no_face_rank.THREE: "3",
	card_no_face_rank.FOUR: "4",
	card_no_face_rank.FIVE: "5",
	card_no_face_rank.SIX: "6",
	card_no_face_rank.SEVEN: "7",
	card_no_face_rank.EIGHT: "8",
	card_no_face_rank.NINE: "9",
	card_no_face_rank.TEN: "10",
	card_no_face_rank.JACK: "jack",
	card_no_face_rank.QUEEN: "queen",
	card_no_face_rank.KING: "king",
}

var suit_dict: Dictionary = {
	card_symbol.SPADE: "spades",
	card_symbol.HEARTS: "hearts",
	card_symbol.CLUBS: "clubs",
	card_symbol.DIAMOND: "diamonds",
}
