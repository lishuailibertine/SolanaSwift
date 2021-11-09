//
//  SolanaInstructionRaw.swift
//  
//
//  Created by math on 2021/11/9.
//

import Foundation

public struct SolanaInstructionRaw: SolanaInstructionBase {
    
    public var promgramId: SolanaPublicKey
    
    public var signers = [SolanaSigner]()
    
    public var data = Data()
    
    public init?(promgramId: SolanaPublicKey, signers: [SolanaSigner], data: Data) {
        self.promgramId = promgramId
        self.signers = signers
        self.data = data
    }
}

extension SolanaInstructionRaw: SolanaHumanReadable {
    public func toHuman() -> Dictionary<String, Any> {
        if promgramId == SolanaPublicKey.OWNERPROGRAMID {
            let type = data.readUInt32(at: 0)
            // SolanaInstructionTransfer
            if type == 2,
                let i = SolanaInstructionTransfer(promgramId: promgramId, signers: signers, data: data) {
                return i.toHuman()
            }
        } else if promgramId == SolanaPublicKey.TOKENPROGRAMID {
            let type = data.readUInt8(at: 0)
            // SolanaInstructionToken
            if type == 3,
                let i = SolanaInstructionToken(promgramId: promgramId, signers: signers, data: data) {
                return i.toHuman()
            }
        }
        
        return [
            "type": "Unknown Type",
            "data": data.toHexString()
        ]
    }
}
