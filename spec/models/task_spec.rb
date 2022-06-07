# frozen_string_literal: true

RSpec.describe Task, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:project) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
  end

  describe 'fields' do
    it { is_expected.to have_db_column(:description).of_type(:string) }
    it { is_expected.to have_db_column(:deadline).of_type(:datetime) }
    it { is_expected.to have_db_column(:position).of_type(:integer) }
    it { is_expected.to have_db_column(:overdue_status).of_type(:integer) }
    it { is_expected.to have_db_column(:is_done).of_type(:boolean) }
  end

  describe 'indexes' do
    it { is_expected.to have_db_index(:project_id) }
  end

  describe 'triggers' do
    subject(:task_is_done) { task.update(is_done: true) }

    let(:task) { create(:task, deadline: deadline) }

    context 'with in time task' do
      let(:deadline) { Time.zone.now - 1.day }

      it 'returns in time overdue status' do
        expect { task_is_done }.to change { task.reload.overdue_status }.to('in_time')
      end
    end

    context 'with overdue task' do
      let(:deadline) { Time.zone.now + 1.day }

      it 'returns in time overdue status' do
        expect { task_is_done }.to change { task.reload.overdue_status }.to('overdue')
      end
    end
  end
end
