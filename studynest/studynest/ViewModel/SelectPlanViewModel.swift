//
//  SelectPlanViewModel.swift
//  studynest
//
//  ViewModel for plan selection
//

import Foundation
import SwiftUI
import Combine

@MainActor
class SelectPlanViewModel: ObservableObject {
    @Published var state: ViewState<[Plan]> = .idle
    @Published var selectedPlan: Plan?
    
    private let repository: StudyNestRepository
    
    init(repository: StudyNestRepository? = nil) {
        self.repository = repository ?? StudyNestRepository()
    }
    
    func loadPlans() async {
        state = .loading
        
        let plans = await repository.getPlans()
        
        state = .success(plans)
        
        // Auto-select recommended plan
        if selectedPlan == nil {
            selectedPlan = plans.first { $0.isRecommended }
        }
    }
    
    func selectPlan(_ plan: Plan) {
        selectedPlan = plan
    }
}
