//
//  HandTracking.swift
//  Ritmo
//
//  Created by Max Pelot on 3/19/24.
//

import ARKit
import SwiftUI

/// A model that contains up-to-date hand coordinate information.
@MainActor
class HandTracking: ObservableObject, @unchecked Sendable {
    let session = ARKitSession()
    var handTracking = HandTrackingProvider()
    @Published var latestHandTracking: HandsUpdates = .init(left: nil, right: nil)
    
    struct HandsUpdates {
        var left: HandAnchor?
        var right: HandAnchor?
    }
    
    struct Hand {
        var hand: HandAnchor
        var thumbIntermediateBase: SIMD3<Float>
        var thumbIntermediateTip: SIMD3<Float>
        var thumbKnuckle: SIMD3<Float>
        var thumbTip: SIMD3<Float>
        var indexFingerIntermediateBase: SIMD3<Float>
        var indexFingerIntermediateTip: SIMD3<Float>
        var indexFingerKnuckle: SIMD3<Float>
        var indexFingerMetacarpal: SIMD3<Float>
        var indexFingerTip: SIMD3<Float>
        var middleFingerIntermediateBase: SIMD3<Float>
        var middleFingerIntermediateTip: SIMD3<Float>
        var middleFingerKnuckle: SIMD3<Float>
        var middleFingerMetacarpal: SIMD3<Float>
        var middleFingerTip: SIMD3<Float>
        var ringFingerIntermediateBase: SIMD3<Float>
        var ringFingerIntermediateTip: SIMD3<Float>
        var ringFingerKnuckle: SIMD3<Float>
        var ringFingerMetacarpal: SIMD3<Float>
        var ringFingerTip: SIMD3<Float>
        var littleFingerIntermediateBase: SIMD3<Float>
        var littleFingerIntermediateTip: SIMD3<Float>
        var littleFingerKnuckle: SIMD3<Float>
        var littleFingerMetacarpal: SIMD3<Float>
        var littleFingerTip: SIMD3<Float>
        var x: SIMD3<Float>
        var y: SIMD3<Float>
        var z: SIMD3<Float>
    }
    
    struct Finger {
        var intermediateBase: SIMD3<Float>
        var intermediateTip: SIMD3<Float>
        var knuckle: SIMD3<Float>
        var metacarpal: SIMD3<Float>
        var tip: SIMD3<Float>
    }
    
    func start() async {
        do {
            if HandTrackingProvider.isSupported {
                print("ARKitSession starting.")
                try await session.run([handTracking])
            }
        } catch {
            print("ARKitSession error:", error)
        }
    }
    
    func publishHandTrackingUpdates() async {
        for await update in handTracking.anchorUpdates {
            switch update.event {
            case .updated:
                let anchor = update.anchor
                
                // Publish updates only if the hand and the relevant joints are tracked.
                guard anchor.isTracked else { continue }
                
                // Update left hand info.
                if anchor.chirality == .left {
                    latestHandTracking.left = anchor
                } else if anchor.chirality == .right { // Update right hand info.
                    latestHandTracking.right = anchor
                }
            default:
                break
            }
        }
    }
    
    func monitorSessionEvents() async {
        for await event in session.events {
            switch event {
            case .authorizationChanged(let type, let status):
                if type == .handTracking && status != .allowed {
                    print("HAND TRACKING NOT ALLOWED")
                    // Stop the game, ask the user to grant hand tracking authorization again in Settings.
                }
            default:
                print("Session event \(event)")
            }
        }
    }
    
    public func checkGesture(_ gesture: String) -> Bool? {
        // Geture is a string with the format: [isLeft]_[gestureName]
        let info = gesture.split(separator: "_")
        if (info.count == 2) {
            let isLeft = info[0] == "left"
            
            switch info[1] {
            case "fist":
                return isFist(isLeft)
            case "open":
                return isOpen(isLeft)
            case "peaceSign":
                return isPeaceSign(isLeft)
            case "fingerGun":
                return isFingerGun(isLeft)
            default:
                return false
            }
        }
        return false;
    }
    
    func isOpen(_ isLeft: Bool) -> Bool? {
        guard let handAnchor = isLeft ? latestHandTracking.left : latestHandTracking.right,
              handAnchor.isTracked else {
            return nil
        }
        let indexTip = handAnchor.handSkeleton?.joint(.indexFingerTip).anchorFromJointTransform.columns.3.xyz
        let middleTip = handAnchor.handSkeleton?.joint(.middleFingerTip).anchorFromJointTransform.columns.3.xyz
        let ringTip = handAnchor.handSkeleton?.joint(.ringFingerTip).anchorFromJointTransform.columns.3.xyz
        let littleTip = handAnchor.handSkeleton?.joint(.littleFingerTip).anchorFromJointTransform.columns.3.xyz
        
        let indexITip = handAnchor.handSkeleton?.joint(.indexFingerIntermediateTip).anchorFromJointTransform.columns.3.xyz
        let middleITip = handAnchor.handSkeleton?.joint(.middleFingerIntermediateTip).anchorFromJointTransform.columns.3.xyz
        let ringITip = handAnchor.handSkeleton?.joint(.ringFingerIntermediateTip).anchorFromJointTransform.columns.3.xyz
        let littleITip = handAnchor.handSkeleton?.joint(.littleFingerIntermediateTip).anchorFromJointTransform.columns.3.xyz
        
        let thumbTip = handAnchor.handSkeleton?.joint(.thumbTip).anchorFromJointTransform.columns.3.xyz
        let thumbITip = handAnchor.handSkeleton?.joint(.thumbIntermediateTip).anchorFromJointTransform.columns.3.xyz
        
        return isLeft ?
        // Left hand logic
        indexTip!.x > indexITip!.x
        && middleTip!.x > middleITip!.x
        && ringTip!.x > ringITip!.x
        && littleTip!.x > littleITip!.x
        && thumbTip!.z < thumbITip!.z
        && thumbTip!.z < indexTip!.z
        && indexTip!.z < middleTip!.z
        && middleTip!.z < ringTip!.z
        && ringTip!.z < littleTip!.z
        :
        // Right hand logic
        indexTip!.x < indexITip!.x
        && middleTip!.x < middleITip!.x
        && ringTip!.x < ringITip!.x
        && littleTip!.x < littleITip!.x
        && thumbTip!.z > thumbITip!.z
        && thumbTip!.z > indexTip!.z
        && indexTip!.z > middleTip!.z
        && middleTip!.z > ringTip!.z
        && ringTip!.z > littleTip!.z
    }
    
    func isFist(_ isLeft: Bool) -> Bool? {
        guard let handAnchor = isLeft ? latestHandTracking.left : latestHandTracking.right,
              handAnchor.isTracked else {
            return nil
        }
        let indexTip = handAnchor.handSkeleton?.joint(.indexFingerTip).anchorFromJointTransform.columns.3.xyz
        let middleTip = handAnchor.handSkeleton?.joint(.middleFingerTip).anchorFromJointTransform.columns.3.xyz
        let ringTip = handAnchor.handSkeleton?.joint(.ringFingerTip).anchorFromJointTransform.columns.3.xyz
        let littleTip = handAnchor.handSkeleton?.joint(.littleFingerTip).anchorFromJointTransform.columns.3.xyz
        
        let indexIBase = handAnchor.handSkeleton?.joint(.indexFingerIntermediateBase).anchorFromJointTransform.columns.3.xyz
        let middleIBase = handAnchor.handSkeleton?.joint(.middleFingerIntermediateBase).anchorFromJointTransform.columns.3.xyz
        let ringIBase = handAnchor.handSkeleton?.joint(.ringFingerIntermediateBase).anchorFromJointTransform.columns.3.xyz
        let littleIBase = handAnchor.handSkeleton?.joint(.littleFingerIntermediateBase).anchorFromJointTransform.columns.3.xyz
        
        let thumbTip = handAnchor.handSkeleton?.joint(.thumbTip).anchorFromJointTransform.columns.3.xyz
        let thumbKnuckle = handAnchor.handSkeleton?.joint(.thumbKnuckle).anchorFromJointTransform.columns.3.xyz
        
        return isLeft ? 
        // Left hand logic
        indexTip!.x < indexIBase!.x
        && middleTip!.x < middleIBase!.x
        && ringTip!.x < ringIBase!.x
        && littleTip!.x < littleIBase!.x
        && thumbTip!.z > thumbKnuckle!.z
        :
        // Right hand logic
        indexTip!.x > indexIBase!.x
        && middleTip!.x > middleIBase!.x
        && ringTip!.x > ringIBase!.x
        && littleTip!.x > littleIBase!.x
        && thumbTip!.z < thumbKnuckle!.z
    }
    
    func isPeaceSign(_ isLeft: Bool) -> Bool? {
        guard let handAnchor = isLeft ? latestHandTracking.left : latestHandTracking.right,
              handAnchor.isTracked else {
            return nil
        }
        let indexTip = handAnchor.handSkeleton?.joint(.indexFingerTip).anchorFromJointTransform.columns.3.xyz
        let middleTip = handAnchor.handSkeleton?.joint(.middleFingerTip).anchorFromJointTransform.columns.3.xyz
        let ringTip = handAnchor.handSkeleton?.joint(.ringFingerTip).anchorFromJointTransform.columns.3.xyz
        let littleTip = handAnchor.handSkeleton?.joint(.littleFingerTip).anchorFromJointTransform.columns.3.xyz
        
        let indexITip = handAnchor.handSkeleton?.joint(.indexFingerIntermediateTip).anchorFromJointTransform.columns.3.xyz
        let middleITip = handAnchor.handSkeleton?.joint(.middleFingerIntermediateTip).anchorFromJointTransform.columns.3.xyz

        let ringIBase = handAnchor.handSkeleton?.joint(.ringFingerIntermediateBase).anchorFromJointTransform.columns.3.xyz
        let littleIBase = handAnchor.handSkeleton?.joint(.littleFingerIntermediateBase).anchorFromJointTransform.columns.3.xyz
        
        let thumbTip = handAnchor.handSkeleton?.joint(.thumbTip).anchorFromJointTransform.columns.3.xyz
        let thumbKnuckle = handAnchor.handSkeleton?.joint(.thumbKnuckle).anchorFromJointTransform.columns.3.xyz
        
        let indexKnuckle = handAnchor.handSkeleton?.joint(.indexFingerKnuckle).anchorFromJointTransform.columns.3.xyz
        let middleKnuckle = handAnchor.handSkeleton?.joint(.middleFingerKnuckle).anchorFromJointTransform.columns.3.xyz
        
        return isLeft ?
        // Left hand logic
        indexTip!.x > indexITip!.x
        && middleTip!.x > middleITip!.x
        && ringTip!.x < ringIBase!.x
        && littleTip!.x < littleIBase!.x
        && thumbTip!.z > thumbKnuckle!.z
        && middleKnuckle!.z - indexKnuckle!.z < middleTip!.z - indexTip!.z
        :
        // Right hand logic
        indexTip!.x < indexITip!.x
        && middleTip!.x < middleITip!.x
        && ringTip!.x > ringIBase!.x
        && littleTip!.x > littleIBase!.x
        && thumbTip!.z < thumbKnuckle!.z
        && indexKnuckle!.z - middleKnuckle!.z < indexTip!.z - middleTip!.z
    }
    
    func isFingerGun(_ isLeft: Bool) -> Bool? {
        guard let handAnchor = isLeft ? latestHandTracking.left : latestHandTracking.right,
              handAnchor.isTracked else {
            return nil
        }
        let indexTip = handAnchor.handSkeleton?.joint(.indexFingerTip).anchorFromJointTransform.columns.3.xyz
        let middleTip = handAnchor.handSkeleton?.joint(.middleFingerTip).anchorFromJointTransform.columns.3.xyz
        let ringTip = handAnchor.handSkeleton?.joint(.ringFingerTip).anchorFromJointTransform.columns.3.xyz
        let littleTip = handAnchor.handSkeleton?.joint(.littleFingerTip).anchorFromJointTransform.columns.3.xyz
        
        let indexITip = handAnchor.handSkeleton?.joint(.indexFingerIntermediateTip).anchorFromJointTransform.columns.3.xyz
        
        let middleIBase = handAnchor.handSkeleton?.joint(.middleFingerIntermediateBase).anchorFromJointTransform.columns.3.xyz
        let ringIBase = handAnchor.handSkeleton?.joint(.ringFingerIntermediateBase).anchorFromJointTransform.columns.3.xyz
        let littleIBase = handAnchor.handSkeleton?.joint(.littleFingerIntermediateBase).anchorFromJointTransform.columns.3.xyz
        
        let thumbTip = handAnchor.handSkeleton?.joint(.thumbTip).anchorFromJointTransform.columns.3.xyz
        let thumbITip = handAnchor.handSkeleton?.joint(.thumbIntermediateTip).anchorFromJointTransform.columns.3.xyz
        
        return isLeft ?
        // Left hand logic
        indexTip!.x > indexITip!.x
        && middleTip!.x < middleIBase!.x
        && ringTip!.x < ringIBase!.x
        && littleTip!.x < littleIBase!.x
        && thumbTip!.z < thumbITip!.z
        :
        // Right hand logic
        indexTip!.x < indexITip!.x
        && middleTip!.x > middleIBase!.x
        && ringTip!.x > ringIBase!.x
        && littleTip!.x > littleIBase!.x
        && thumbTip!.z > thumbITip!.z
    }
    
    func getHands()  -> [Hand]? {
        guard let leftHandAnchor = latestHandTracking.left,
              let rightHandAnchor = latestHandTracking.right,
              leftHandAnchor.isTracked, rightHandAnchor.isTracked else {
            return nil
        }
        guard
            let thumbIntermediateBaseL = leftHandAnchor.handSkeleton?.joint(.thumbIntermediateBase),
            let thumbIntermediateTipL = leftHandAnchor.handSkeleton?.joint(.thumbIntermediateTip),
            let thumbKnuckleL = leftHandAnchor.handSkeleton?.joint(.thumbKnuckle),
            let thumbTipL = leftHandAnchor.handSkeleton?.joint(.thumbTip),
            let indexFingerIntermediateBaseL = leftHandAnchor.handSkeleton?.joint(.indexFingerIntermediateBase),
            let indexFingerIntermediateTipL = leftHandAnchor.handSkeleton?.joint(.indexFingerIntermediateTip),
            let indexFingerKnuckleL = leftHandAnchor.handSkeleton?.joint(.indexFingerKnuckle),
            let indexFingerMetacarpalL = leftHandAnchor.handSkeleton?.joint(.indexFingerMetacarpal),
            let indexFingerTipL = leftHandAnchor.handSkeleton?.joint(.indexFingerTip),
            let middleFingerIntermediateBaseL = leftHandAnchor.handSkeleton?.joint(.middleFingerIntermediateBase),
            let middleFingerIntermediateTipL = leftHandAnchor.handSkeleton?.joint(.middleFingerIntermediateTip),
            let middleFingerKnuckleL = leftHandAnchor.handSkeleton?.joint(.middleFingerKnuckle),
            let middleFingerMetacarpalL = leftHandAnchor.handSkeleton?.joint(.middleFingerMetacarpal),
            let middleFingerTipL = leftHandAnchor.handSkeleton?.joint(.middleFingerTip),
            let ringFingerIntermediateBaseL = leftHandAnchor.handSkeleton?.joint(.ringFingerIntermediateBase),
            let ringFingerIntermediateTipL = leftHandAnchor.handSkeleton?.joint(.ringFingerIntermediateTip),
            let ringFingerKnuckleL = leftHandAnchor.handSkeleton?.joint(.ringFingerKnuckle),
            let ringFingerMetacarpalL = leftHandAnchor.handSkeleton?.joint(.ringFingerMetacarpal),
            let ringFingerTipL = leftHandAnchor.handSkeleton?.joint(.ringFingerTip),
            let littleFingerIntermediateBaseL = leftHandAnchor.handSkeleton?.joint(.littleFingerIntermediateBase),
            let littleFingerIntermediateTipL = leftHandAnchor.handSkeleton?.joint(.littleFingerIntermediateTip),
            let littleFingerKnuckleL = leftHandAnchor.handSkeleton?.joint(.littleFingerKnuckle),
            let littleFingerMetacarpalL = leftHandAnchor.handSkeleton?.joint(.littleFingerMetacarpal),
            let littleFingerTipL = leftHandAnchor.handSkeleton?.joint(.littleFingerTip),
                
            let thumbIntermediateBaseR = rightHandAnchor.handSkeleton?.joint(.thumbIntermediateBase),
            let thumbIntermediateTipR = rightHandAnchor.handSkeleton?.joint(.thumbIntermediateTip),
            let thumbKnuckleR = rightHandAnchor.handSkeleton?.joint(.thumbKnuckle),
            let thumbTipR = rightHandAnchor.handSkeleton?.joint(.thumbTip),
            let indexFingerIntermediateBaseR = rightHandAnchor.handSkeleton?.joint(.indexFingerIntermediateBase),
            let indexFingerIntermediateTipR = rightHandAnchor.handSkeleton?.joint(.indexFingerIntermediateTip),
            let indexFingerKnuckleR = rightHandAnchor.handSkeleton?.joint(.indexFingerKnuckle),
            let indexFingerMetacarpalR = rightHandAnchor.handSkeleton?.joint(.indexFingerMetacarpal),
            let indexFingerTipR = rightHandAnchor.handSkeleton?.joint(.indexFingerTip),
            let middleFingerIntermediateBaseR = rightHandAnchor.handSkeleton?.joint(.middleFingerIntermediateBase),
            let middleFingerIntermediateTipR = rightHandAnchor.handSkeleton?.joint(.middleFingerIntermediateTip),
            let middleFingerKnuckleR = rightHandAnchor.handSkeleton?.joint(.middleFingerKnuckle),
            let middleFingerMetacarpalR = rightHandAnchor.handSkeleton?.joint(.middleFingerMetacarpal),
            let middleFingerTipR = rightHandAnchor.handSkeleton?.joint(.middleFingerTip),
            let ringFingerIntermediateBaseR = rightHandAnchor.handSkeleton?.joint(.ringFingerIntermediateBase),
            let ringFingerIntermediateTipR = rightHandAnchor.handSkeleton?.joint(.ringFingerIntermediateTip),
            let ringFingerKnuckleR = rightHandAnchor.handSkeleton?.joint(.ringFingerKnuckle),
            let ringFingerMetacarpalR = rightHandAnchor.handSkeleton?.joint(.ringFingerMetacarpal),
            let ringFingerTipR = rightHandAnchor.handSkeleton?.joint(.ringFingerTip),
            let littleFingerIntermediateBaseR = rightHandAnchor.handSkeleton?.joint(.littleFingerIntermediateBase),
            let littleFingerIntermediateTipR = rightHandAnchor.handSkeleton?.joint(.littleFingerIntermediateTip),
            let littleFingerKnuckleR = rightHandAnchor.handSkeleton?.joint(.littleFingerKnuckle),
            let littleFingerMetacarpalR = rightHandAnchor.handSkeleton?.joint(.littleFingerMetacarpal),
            let littleFingerTipR = rightHandAnchor.handSkeleton?.joint(.littleFingerTip)
        else {
            return nil
        }
        
        let thumbIntermediateBaseTransformL = matrix_multiply(
            leftHandAnchor.originFromAnchorTransform, thumbIntermediateBaseL.anchorFromJointTransform
        ).columns.3.xyz

        let thumbIntermediateTipTransformL = matrix_multiply(
            leftHandAnchor.originFromAnchorTransform, thumbIntermediateTipL.anchorFromJointTransform
        ).columns.3.xyz

        let thumbKnuckleTransformL = matrix_multiply(
            leftHandAnchor.originFromAnchorTransform, thumbKnuckleL.anchorFromJointTransform
        ).columns.3.xyz

        let thumbTipTransformL = matrix_multiply(
            leftHandAnchor.originFromAnchorTransform, thumbTipL.anchorFromJointTransform
        ).columns.3.xyz

        let indexFingerIntermediateBaseTransformL = matrix_multiply(
            leftHandAnchor.originFromAnchorTransform, indexFingerIntermediateBaseL.anchorFromJointTransform
        ).columns.3.xyz

        let indexFingerIntermediateTipTransformL = matrix_multiply(
            leftHandAnchor.originFromAnchorTransform, indexFingerIntermediateTipL.anchorFromJointTransform
        ).columns.3.xyz

        let indexFingerKnuckleTransformL = matrix_multiply(
            leftHandAnchor.originFromAnchorTransform, indexFingerKnuckleL.anchorFromJointTransform
        ).columns.3.xyz

        let indexFingerMetacarpalTransformL = matrix_multiply(
            leftHandAnchor.originFromAnchorTransform, indexFingerMetacarpalL.anchorFromJointTransform
        ).columns.3.xyz
        
        let posL = indexFingerMetacarpalL.anchorFromJointTransform.columns.3.xyz
        
        let xMatrix = simd_matrix(
            indexFingerMetacarpalL.anchorFromJointTransform.columns.0,
            indexFingerMetacarpalL.anchorFromJointTransform.columns.1,
            indexFingerMetacarpalL.anchorFromJointTransform.columns.2,
            SIMD4(posL.x + 0.2, posL.y, posL.z, 1))
        
        let xL = matrix_multiply(
            leftHandAnchor.originFromAnchorTransform, xMatrix
        ).columns.3.xyz
        
        let yMatrix = simd_matrix(
            indexFingerMetacarpalL.anchorFromJointTransform.columns.0,
            indexFingerMetacarpalL.anchorFromJointTransform.columns.1,
            indexFingerMetacarpalL.anchorFromJointTransform.columns.2,
            SIMD4(posL.x, posL.y + 0.2, posL.z, 1))
        
        let yL = matrix_multiply(
            leftHandAnchor.originFromAnchorTransform, yMatrix
        ).columns.3.xyz
        
        let zMatrix = simd_matrix(
            indexFingerMetacarpalL.anchorFromJointTransform.columns.0,
            indexFingerMetacarpalL.anchorFromJointTransform.columns.1,
            indexFingerMetacarpalL.anchorFromJointTransform.columns.2,
            SIMD4(posL.x, posL.y, posL.z + 0.2, 1))
        
        let zL = matrix_multiply(
            leftHandAnchor.originFromAnchorTransform, zMatrix
        ).columns.3.xyz

        let indexFingerTipTransformL = matrix_multiply(
            leftHandAnchor.originFromAnchorTransform, indexFingerTipL.anchorFromJointTransform
        ).columns.3.xyz

        let middleFingerIntermediateBaseTransformL = matrix_multiply(
            leftHandAnchor.originFromAnchorTransform, middleFingerIntermediateBaseL.anchorFromJointTransform
        ).columns.3.xyz

        let middleFingerIntermediateTipTransformL = matrix_multiply(
            leftHandAnchor.originFromAnchorTransform, middleFingerIntermediateTipL.anchorFromJointTransform
        ).columns.3.xyz

        let middleFingerKnuckleTransformL = matrix_multiply(
            leftHandAnchor.originFromAnchorTransform, middleFingerKnuckleL.anchorFromJointTransform
        ).columns.3.xyz

        let middleFingerMetacarpalTransformL = matrix_multiply(
            leftHandAnchor.originFromAnchorTransform, middleFingerMetacarpalL.anchorFromJointTransform
        ).columns.3.xyz

        let middleFingerTipTransformL = matrix_multiply(
            leftHandAnchor.originFromAnchorTransform, middleFingerTipL.anchorFromJointTransform
        ).columns.3.xyz

        let ringFingerIntermediateBaseTransformL = matrix_multiply(
            leftHandAnchor.originFromAnchorTransform, ringFingerIntermediateBaseL.anchorFromJointTransform
        ).columns.3.xyz

        let ringFingerIntermediateTipTransformL = matrix_multiply(
            leftHandAnchor.originFromAnchorTransform, ringFingerIntermediateTipL.anchorFromJointTransform
        ).columns.3.xyz

        let ringFingerKnuckleTransformL = matrix_multiply(
            leftHandAnchor.originFromAnchorTransform, ringFingerKnuckleL.anchorFromJointTransform
        ).columns.3.xyz

        let ringFingerMetacarpalTransformL = matrix_multiply(
            leftHandAnchor.originFromAnchorTransform, ringFingerMetacarpalL.anchorFromJointTransform
        ).columns.3.xyz

        let ringFingerTipTransformL = matrix_multiply(
            leftHandAnchor.originFromAnchorTransform, ringFingerTipL.anchorFromJointTransform
        ).columns.3.xyz

        let littleFingerIntermediateBaseTransformL = matrix_multiply(
            leftHandAnchor.originFromAnchorTransform, littleFingerIntermediateBaseL.anchorFromJointTransform
        ).columns.3.xyz

        let littleFingerIntermediateTipTransformL = matrix_multiply(
            leftHandAnchor.originFromAnchorTransform, littleFingerIntermediateTipL.anchorFromJointTransform
        ).columns.3.xyz

        let littleFingerKnuckleTransformL = matrix_multiply(
            leftHandAnchor.originFromAnchorTransform, littleFingerKnuckleL.anchorFromJointTransform
        ).columns.3.xyz

        let littleFingerMetacarpalTransformL = matrix_multiply(
            leftHandAnchor.originFromAnchorTransform, littleFingerMetacarpalL.anchorFromJointTransform
        ).columns.3.xyz

        let littleFingerTipTransformL = matrix_multiply(
            leftHandAnchor.originFromAnchorTransform, littleFingerTipL.anchorFromJointTransform
        ).columns.3.xyz
    
        
        let thumbIntermediateBaseTransformR = matrix_multiply(
            rightHandAnchor.originFromAnchorTransform, thumbIntermediateBaseR.anchorFromJointTransform
        ).columns.3.xyz

        let thumbIntermediateTipTransformR = matrix_multiply(
            rightHandAnchor.originFromAnchorTransform, thumbIntermediateTipR.anchorFromJointTransform
        ).columns.3.xyz

        let thumbKnuckleTransformR = matrix_multiply(
            rightHandAnchor.originFromAnchorTransform, thumbKnuckleR.anchorFromJointTransform
        ).columns.3.xyz

        let thumbTipTransformR = matrix_multiply(
            rightHandAnchor.originFromAnchorTransform, thumbTipR.anchorFromJointTransform
        ).columns.3.xyz

        let indexFingerIntermediateBaseTransformR = matrix_multiply(
            rightHandAnchor.originFromAnchorTransform, indexFingerIntermediateBaseR.anchorFromJointTransform
        ).columns.3.xyz

        let indexFingerIntermediateTipTransformR = matrix_multiply(
            rightHandAnchor.originFromAnchorTransform, indexFingerIntermediateTipR.anchorFromJointTransform
        ).columns.3.xyz

        let indexFingerKnuckleTransformR = matrix_multiply(
            rightHandAnchor.originFromAnchorTransform, indexFingerKnuckleR.anchorFromJointTransform
        ).columns.3.xyz

        let indexFingerMetacarpalTransformR = matrix_multiply(
            rightHandAnchor.originFromAnchorTransform, indexFingerMetacarpalR.anchorFromJointTransform
        ).columns.3.xyz
        
        let posR = indexFingerMetacarpalR.anchorFromJointTransform.columns.3.xyz
        
        let xMatrixR = simd_matrix(
            indexFingerMetacarpalR.anchorFromJointTransform.columns.0,
            indexFingerMetacarpalR.anchorFromJointTransform.columns.1,
            indexFingerMetacarpalR.anchorFromJointTransform.columns.2,
            SIMD4(posR.x - 0.2, posR.y, posR.z, 1))
        
        let xR = matrix_multiply(
            rightHandAnchor.originFromAnchorTransform, xMatrixR
        ).columns.3.xyz
        
        let yMatrixR = simd_matrix(
            indexFingerMetacarpalR.anchorFromJointTransform.columns.0,
            indexFingerMetacarpalR.anchorFromJointTransform.columns.1,
            indexFingerMetacarpalR.anchorFromJointTransform.columns.2,
            SIMD4(posR.x, posR.y + 0.2, posR.z, 1))
        
        let yR = matrix_multiply(
            rightHandAnchor.originFromAnchorTransform, yMatrixR
        ).columns.3.xyz
        
        let zMatrixR = simd_matrix(
            indexFingerMetacarpalR.anchorFromJointTransform.columns.0,
            indexFingerMetacarpalR.anchorFromJointTransform.columns.1,
            indexFingerMetacarpalR.anchorFromJointTransform.columns.2,
            SIMD4(posR.x, posR.y, posR.z + 0.2, 1))
        
        let zR = matrix_multiply(
            rightHandAnchor.originFromAnchorTransform, zMatrixR
        ).columns.3.xyz

        let indexFingerTipTransformR = matrix_multiply(
            rightHandAnchor.originFromAnchorTransform, indexFingerTipR.anchorFromJointTransform
        ).columns.3.xyz

        let middleFingerIntermediateBaseTransformR = matrix_multiply(
            rightHandAnchor.originFromAnchorTransform, middleFingerIntermediateBaseR.anchorFromJointTransform
        ).columns.3.xyz

        let middleFingerIntermediateTipTransformR = matrix_multiply(
            rightHandAnchor.originFromAnchorTransform, middleFingerIntermediateTipR.anchorFromJointTransform
        ).columns.3.xyz

        let middleFingerKnuckleTransformR = matrix_multiply(
            rightHandAnchor.originFromAnchorTransform, middleFingerKnuckleR.anchorFromJointTransform
        ).columns.3.xyz

        let middleFingerMetacarpalTransformR = matrix_multiply(
            rightHandAnchor.originFromAnchorTransform, middleFingerMetacarpalR.anchorFromJointTransform
        ).columns.3.xyz

        let middleFingerTipTransformR = matrix_multiply(
            rightHandAnchor.originFromAnchorTransform, middleFingerTipR.anchorFromJointTransform
        ).columns.3.xyz

        let ringFingerIntermediateBaseTransformR = matrix_multiply(
            rightHandAnchor.originFromAnchorTransform, ringFingerIntermediateBaseR.anchorFromJointTransform
        ).columns.3.xyz

        let ringFingerIntermediateTipTransformR = matrix_multiply(
            rightHandAnchor.originFromAnchorTransform, ringFingerIntermediateTipR.anchorFromJointTransform
        ).columns.3.xyz

        let ringFingerKnuckleTransformR = matrix_multiply(
            rightHandAnchor.originFromAnchorTransform, ringFingerKnuckleR.anchorFromJointTransform
        ).columns.3.xyz

        let ringFingerMetacarpalTransformR = matrix_multiply(
            rightHandAnchor.originFromAnchorTransform, ringFingerMetacarpalR.anchorFromJointTransform
        ).columns.3.xyz

        let ringFingerTipTransformR = matrix_multiply(
            rightHandAnchor.originFromAnchorTransform, ringFingerTipR.anchorFromJointTransform
        ).columns.3.xyz

        let littleFingerIntermediateBaseTransformR = matrix_multiply(
            rightHandAnchor.originFromAnchorTransform, littleFingerIntermediateBaseR.anchorFromJointTransform
        ).columns.3.xyz

        let littleFingerIntermediateTipTransformR = matrix_multiply(
            rightHandAnchor.originFromAnchorTransform, littleFingerIntermediateTipR.anchorFromJointTransform
        ).columns.3.xyz

        let littleFingerKnuckleTransformR = matrix_multiply(
            rightHandAnchor.originFromAnchorTransform, littleFingerKnuckleR.anchorFromJointTransform
        ).columns.3.xyz

        let littleFingerMetacarpalTransformR = matrix_multiply(
            rightHandAnchor.originFromAnchorTransform, littleFingerMetacarpalR.anchorFromJointTransform
        ).columns.3.xyz

        let littleFingerTipTransformR = matrix_multiply(
            rightHandAnchor.originFromAnchorTransform, littleFingerTipR.anchorFromJointTransform
        ).columns.3.xyz
        
        let leftHand = Hand(
            hand: leftHandAnchor,
            thumbIntermediateBase: thumbIntermediateBaseTransformL,
            thumbIntermediateTip: thumbIntermediateTipTransformL,
            thumbKnuckle: thumbKnuckleTransformL,
            thumbTip: thumbTipTransformL,
            indexFingerIntermediateBase: indexFingerIntermediateBaseTransformL,
            indexFingerIntermediateTip: indexFingerIntermediateTipTransformL,
            indexFingerKnuckle: indexFingerKnuckleTransformL,
            indexFingerMetacarpal: indexFingerMetacarpalTransformL,
            indexFingerTip: indexFingerTipTransformL,
            middleFingerIntermediateBase: middleFingerIntermediateBaseTransformL,
            middleFingerIntermediateTip: middleFingerIntermediateTipTransformL,
            middleFingerKnuckle: middleFingerKnuckleTransformL,
            middleFingerMetacarpal: middleFingerMetacarpalTransformL,
            middleFingerTip: middleFingerTipTransformL,
            ringFingerIntermediateBase: ringFingerIntermediateBaseTransformL,
            ringFingerIntermediateTip: ringFingerIntermediateTipTransformL,
            ringFingerKnuckle: ringFingerKnuckleTransformL,
            ringFingerMetacarpal: ringFingerMetacarpalTransformL,
            ringFingerTip: ringFingerTipTransformL,
            littleFingerIntermediateBase: littleFingerIntermediateBaseTransformL,
            littleFingerIntermediateTip: littleFingerIntermediateTipTransformL,
            littleFingerKnuckle: littleFingerKnuckleTransformL,
            littleFingerMetacarpal: littleFingerMetacarpalTransformL,
            littleFingerTip: littleFingerTipTransformL,
            x: xL,
            y: yL,
            z: zL
        )
        
        let rightHand = Hand(
            hand: rightHandAnchor,
            thumbIntermediateBase: thumbIntermediateBaseTransformR,
            thumbIntermediateTip: thumbIntermediateTipTransformR,
            thumbKnuckle: thumbKnuckleTransformR,
            thumbTip: thumbTipTransformR,
            indexFingerIntermediateBase: indexFingerIntermediateBaseTransformR,
            indexFingerIntermediateTip: indexFingerIntermediateTipTransformR,
            indexFingerKnuckle: indexFingerKnuckleTransformR,
            indexFingerMetacarpal: indexFingerMetacarpalTransformR,
            indexFingerTip: indexFingerTipTransformR,
            middleFingerIntermediateBase: middleFingerIntermediateBaseTransformR,
            middleFingerIntermediateTip: middleFingerIntermediateTipTransformR,
            middleFingerKnuckle: middleFingerKnuckleTransformR,
            middleFingerMetacarpal: middleFingerMetacarpalTransformR,
            middleFingerTip: middleFingerTipTransformR,
            ringFingerIntermediateBase: ringFingerIntermediateBaseTransformR,
            ringFingerIntermediateTip: ringFingerIntermediateTipTransformR,
            ringFingerKnuckle: ringFingerKnuckleTransformR,
            ringFingerMetacarpal: ringFingerMetacarpalTransformR,
            ringFingerTip: ringFingerTipTransformR,
            littleFingerIntermediateBase: littleFingerIntermediateBaseTransformR,
            littleFingerIntermediateTip: littleFingerIntermediateTipTransformR,
            littleFingerKnuckle: littleFingerKnuckleTransformR,
            littleFingerMetacarpal: littleFingerMetacarpalTransformR,
            littleFingerTip: littleFingerTipTransformR,
            x: xR,
            y: yR,
            z: zR
        )

        return [leftHand, rightHand]
    }
}

extension SIMD4 {
    var xyz: SIMD3<Scalar> {
        self[SIMD3(0, 1, 2)]
    }
}
