class AddInvoicesReferencesToMerchants < ActiveRecord::Migration[5.2]
  def change
    add_reference :merchants, :invoices, foreign_key: true
  end
end
