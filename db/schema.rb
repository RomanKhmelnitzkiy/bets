# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_03_27_110111) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_statements", force: :cascade do |t|
    t.decimal "amount"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_account_statements_on_user_id"
  end

  create_table "bet_items", force: :cascade do |t|
    t.string "choise"
    t.bigint "bet_id", null: false
    t.bigint "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bet_id"], name: "index_bet_items_on_bet_id"
    t.index ["event_id"], name: "index_bet_items_on_event_id"
  end

  create_table "bets", force: :cascade do |t|
    t.decimal "ratio"
    t.decimal "bet_amount"
    t.string "result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_bets_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "alias"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alias"], name: "index_categories_on_alias", unique: true
  end

  create_table "events", force: :cascade do |t|
    t.string "team1"
    t.string "team2"
    t.decimal "win_ratio_1"
    t.decimal "win_ratio_2"
    t.decimal "draw_ratio"
    t.datetime "dattime"
    t.string "result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "category_id"
    t.index ["category_id"], name: "index_events_on_category_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password"
    t.decimal "money"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "apitoken"
  end

  add_foreign_key "bets", "users"
end
