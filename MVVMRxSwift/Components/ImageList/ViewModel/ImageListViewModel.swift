//
//  Copyright © 2019 An Tran. All rights reserved.
//

import RxSwift
import RxRelay
import PromiseKit

class ImageListViewModel: ViewModel {

    // MARK: Properties

    var searchTerm = BehaviorRelay<String>(value: "")
    var imageList = BehaviorRelay<ImageList>(value: ImageList(total: 0, totalHits: 0, hits: []))

    private let disposeBag = DisposeBag()

    // MARK: APIs

    override init(service: ServiceProtocol) {
        super.init(service: service)

        searchTerm.subscribe(onNext: { value in
            if value.count > 2 {
                self.fetchImage(searchTerm: value)
            }
        }).disposed(by: disposeBag)
    }

    func fetchImage(searchTerm: String) {
        pixelBayService.fetch(searchTerm: searchTerm)
            .done { [weak self] imageList in
                self?.imageList.accept(imageList)
            }
            .catch { error in
                print(error)
            }
    }
}

extension ImageListViewModel {
    var pixelBayService: PixelBayService {
        return service as! PixelBayService
    }
}
