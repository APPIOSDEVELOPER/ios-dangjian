//
//  AddItemViewController.swift
//  StudyApp
//


import UIKit

class AddItemViewController: SuperBaseViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    var dataSource = [[String]]();
    var isEdit = false;
    
    var finished: (([String]) -> Void)!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        dataSource.append(["反腐","政治","十九大","国际新闻"])
        
        let layout = UICollectionViewFlowLayout();
        layout.itemSize = .init(width: 74 , height: 25);
        layout.sectionInset = UIEdge(size: 14);
        layout.minimumLineSpacing = 15;
        layout.headerReferenceSize = .init(width: width(), height: 35);
        layout.minimumInteritemSpacing = (width() - 74 * 4 - 31)/3;
        
        createCollection(frame: navigateRect, layout: layout, delegate: self);
        baseCollectionView.delegate = self;
        baseCollectionView.dataSource = self;
        baseCollectionView.register(AddItemCollectionCell.classForCoder(), forCellWithReuseIdentifier: "AddItemCollectionCell");
        baseCollectionView.register(AddItemCollectionHeader.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header");
        
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(longTap(_:)));
        baseCollectionView.addGestureRecognizer(longTap);
        
        let refreshItem = UIBarButtonItem(title: "编辑", style: .plain, target: self, action: #selector(buttonItemAction(_:)));
        self.navigationItem.rightBarButtonItem = refreshItem;
        refreshItem.tag = ViewTagSense.refreshTag.rawValue;
        
        
        let backItem = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(buttonItemAction(_:)));
        self.navigationItem.leftBarButtonItem = backItem;
        backItem.tag = ViewTagSense.backTag.rawValue;
        
        
    }
    
    override func buttonItemAction(_ item: UIBarButtonItem) {
        if item.tag == ViewTagSense.refreshTag.rawValue {
            isEdit = !isEdit;
            item.title = isEdit ? "完成" : "编辑";
            baseCollectionView.reloadData();
        }else if item.tag == ViewTagSense.backTag.rawValue {
            finished?(dataSource[0]);
            navigateCtrl.popViewController(animated: true);
        }
        
    }
    
    var cell: AddItemCollectionCell?

   @objc func longTap(_ tap:UILongPressGestureRecognizer) -> Void {
        var point = CGPoint.zero;
        
        switch tap.state {
        case .began:
            baseCollectionView.performBatchUpdates({
                var fs = dataSource[0];
                fs.append("12");
                dataSource[0] = fs;
                
                baseCollectionView.insertItems(at: [IndexPath.init(item: 0, section: 0)]);
            }, completion: { (tag) in
                
            })
            
            point = tap.location(in: baseCollectionView);
            guard let indexPath = baseCollectionView.indexPathForItem(at: point) else{
                return;
            }
            baseCollectionView.beginInteractiveMovementForItem(at: indexPath);
            cell = baseCollectionView.cellForItem(at: indexPath) as? AddItemCollectionCell;
            cell?.isLongTop = true;
            baseCollectionView.updateInteractiveMovementTargetPosition(point);

        case .changed:
            
            point = tap.location(in: baseCollectionView);
            baseCollectionView.updateInteractiveMovementTargetPosition(point);
            cell?.isLongTop = true;

            
        case .ended:
            cell?.isLongTop = false;

            baseCollectionView.endInteractiveMovement();
        case .cancelled:
            cell?.isLongTop = false;

            baseCollectionView.cancelInteractiveMovement();
        default:
            break;
        }
    }
    
    @objc override func buttonAction(btn: UIButton) {
        let cell = btn.superview as? AddItemCollectionCell;
        let indexPath = baseCollectionView.indexPath(for: cell!)!;
        
        
        if indexPath.section == 0 {
            
            var tempData = dataSource[indexPath.section];
            
            let tempItem = tempData.remove(at: indexPath.row);
            dataSource[indexPath.section] = tempData;
            
            var otherData = dataSource[1];
            otherData.insert(tempItem, at: 0);
            dataSource[1] = otherData;

            baseCollectionView.performBatchUpdates({
                baseCollectionView.moveItem(at: indexPath, to: IndexPath.init(row: 0, section: 1))

            }) { (finished) in
                if finished {
                    self.baseCollectionView.reloadData();
                }
            }
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 && indexPath.section == 0 {
            return false;
        }
        return true;
    }
  
//    toProposedIndexPath
    func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        
        if proposedIndexPath.section == 0 && proposedIndexPath.row == 0 {
            return originalIndexPath;
        }
        return proposedIndexPath;
    }
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        
        var tempSource = dataSource;

        var sourceItemSection = dataSource[sourceIndexPath.section];
        let sourceItem = sourceItemSection[sourceIndexPath.row];
        sourceItemSection.remove(at: sourceIndexPath.row);

        if sourceIndexPath.section == destinationIndexPath.section {
            sourceItemSection.insert(sourceItem, at: destinationIndexPath.row);
        }else{
            var otherSection = dataSource[destinationIndexPath.section];
            otherSection.insert(sourceItem, at: destinationIndexPath.row);
            tempSource[destinationIndexPath.section] = otherSection;
            
        }
        tempSource[sourceIndexPath.section] = sourceItemSection;
        dataSource = tempSource;

    }

    // MARK:- collection view delegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! AddItemCollectionHeader;
        header.titleLabel.text = indexPath.section == 0 ? "我的频道" : "添加频道";
        header.backgroundColor = rgbColor(rgb: 234);
        return header;
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        let sectionItem = dataSource[section];
        return sectionItem.count;
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddItemCollectionCell", for: indexPath) as! AddItemCollectionCell;
        cell.contentType = .onlyTitle;
        cell.backgroundColor = rgbColor(rgb: 221).withAlphaComponent(0.8);
        let sectionItem = dataSource[indexPath.section];
        cell.titleLabel.text = sectionItem[indexPath.row];
        cell.indexPath = indexPath;
        cell.isEdit = isEdit;

        cell.titleButton.addTarget(self, action: #selector(buttonAction(btn:)), for: .touchUpInside);
        return cell;
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        if indexPath.section == 1 {
            var sourData = dataSource[1];
            let sourItem = sourData.remove(at: indexPath.row);
            
            var desData = dataSource[0];
            desData.insert(sourItem, at: 1);
            
            dataSource[1] = sourData;
            dataSource[0] = desData;
            
            collectionView.performBatchUpdates({
                collectionView.moveItem(at: indexPath, to: IndexPath.init(row: 1, section: 0));
            }, completion: { (finished) in
                if finished {
                    collectionView.reloadData();
                }
            })
            
            
            
        }
        
    }

}

class AddItemCollectionCell: BaseCollectionViewCell {
    
    
}


class AddItemCollectionHeader: UICollectionReusableView{
    
    var titleLabel: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        titleLabel = UILabel(frame: .zero);
        titleLabel.textColor = UIColor.darkText;
        titleLabel.font = fontSize(size: 12);
        addSubview(titleLabel);
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(10);
            maker.height.equalTo(self.snp.height);
            maker.top.equalTo(0);
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




