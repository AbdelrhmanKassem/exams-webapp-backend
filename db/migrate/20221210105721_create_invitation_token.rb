class CreateInvitationToken < ActiveRecord::Migration[7.0]
  def change
    create_table :password_reset_tokens, id: false do |t|
      t.references :user, null: false, foreign_key: true, primary_key: true
      t.string :token_hash, null: false, index: true, unique: true
    end
  end
end
