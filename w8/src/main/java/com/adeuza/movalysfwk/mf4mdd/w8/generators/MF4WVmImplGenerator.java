/**
 * Copyright (C) 2010 Sopra Steria Group (movalys.support@soprasteria.com)
 *
 * This file is part of Movalys MDK.
 * Movalys MDK is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * Movalys MDK is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * You should have received a copy of the GNU Lesser General Public License
 * along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.
 */
package com.adeuza.movalysfwk.mf4mdd.w8.generators;

import org.dom4j.Document;

import com.a2a.adjava.languages.w8.generators.VMImplGenerator;
import com.a2a.adjava.languages.w8.xmodele.MW8ImportDelegate;
import com.a2a.adjava.xmodele.IDomain;
import com.a2a.adjava.xmodele.IModelDictionary;
import com.a2a.adjava.xmodele.IModelFactory;
import com.a2a.adjava.xmodele.MAssociation;
import com.a2a.adjava.xmodele.MAssociation.AssociationType;
import com.a2a.adjava.xmodele.MEntityImpl;
import com.a2a.adjava.xmodele.MViewModelImpl;
import com.a2a.adjava.xmodele.XProject;
import com.a2a.adjava.xmodele.ui.viewmodel.ViewModelType;
import com.a2a.adjava.xmodele.ui.viewmodel.mappings.IVMMappingDesc;
import com.a2a.adjava.xmodele.ui.viewmodel.mappings.MMappingAttribute;
import com.a2a.adjava.xmodele.ui.viewmodel.mappings.MMappingEntity;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MDataLoader;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MDataLoaderCombo;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFViewModel;
import com.adeuza.movalysfwk.mf4mdd.w8.xmodele.MF4WImportDelegate;

/**
 * @author lmichenaud
 *
 */
public class MF4WVmImplGenerator extends VMImplGenerator {

	
	/**
	 * {@inheritDoc}
	 * @see com.a2a.adjava.generator.impl.ViewModelGenerator#createDocument(com.a2a.adjava.xmodele.MViewModelImpl, com.a2a.adjava.xmodele.XProject)
	 */
	@Override
	protected Document createDocument(MViewModelImpl p_oMViewModel,
			XProject<IDomain<IModelDictionary, IModelFactory>> p_oProject) {
		Document r_xViewModel = super.createDocument(p_oMViewModel, p_oProject);

		MFViewModel oVm = (MFViewModel) p_oMViewModel;

		MF4WImportDelegate oImportDlg = new MF4WImportDelegate(this);
		oImportDlg.addImport(MW8ImportDelegate.MW8ImportCategory.VIEWMODEL.name(), p_oMViewModel.getPackage().getFullName());
		oImportDlg.addImport(MW8ImportDelegate.MW8ImportCategory.VIEWMODEL.name(), p_oProject.getDomain().getDictionnary().getViewModelCreator().getPackage().getFullName());

		if ( oVm.getEntityToUpdate() != null ) {
			MEntityImpl oEntity = oVm.getEntityToUpdate();
			oImportDlg.addImport(MW8ImportDelegate.MW8ImportCategory.ENTITIES.name(), oEntity.getPackage().getFullName());
			
			//On ajoute en import la factory de l'entité mise à jour par ce view model
			//oImportDlg.addImport(MW8ImportDelegate.MW8ImportCategory.FACTORIES.name(), oEntity.getFactory().getPackage().getFullName());
			
			for( MAssociation oAssociation : oEntity.getAssociations()) {
				if ( !oAssociation.isSelfRef() && 
						(oAssociation.getAssociationType().equals(AssociationType.MANY_TO_ONE) |
								oAssociation.getAssociationType().equals(AssociationType.ONE_TO_MANY) ||
								oAssociation.getAssociationType().equals(AssociationType.ONE_TO_ONE) ||
								oAssociation.getAssociationType().equals(AssociationType.MANY_TO_MANY))) {
					oImportDlg.addImport(MW8ImportDelegate.MW8ImportCategory.ENTITIES.name(), oAssociation.getRefClass().getMasterInterface().getPackage().getFullName());
					//oImportDlg.addImport(MW8ImportDelegate.MW8ImportCategory.FACTORIES.name(), oAssociation.getRefClass().getFactory().getPackage().getFullName());
					if ( !oAssociation.getRefClass().isTransient()) {
						oImportDlg.addImport(MW8ImportDelegate.MW8ImportCategory.ENTITIES.name(), oAssociation.getRefClass().getMasterInterface().getPackage().getFullName());
					}
				}
			}
		}

		addImportFactoryFromMapping(oVm.getMapping(), oImportDlg);

		if ( oVm.getDataLoader() != null ||
				oVm.getType() == ViewModelType.LISTITEM_2 ||
				oVm.getType() == ViewModelType.LISTITEM_3) {
			//oImportDlg.addImport(MW8ImportDelegate.MW8ImportCategory.VIEWMODEL.name(), p_oProject.getDomain().getDictionnary().getViewModelCreator().getPackage().getFullName());
			if(oVm.getDataLoader() != null) {
				oImportDlg.addImport(MF4WImportDelegate.MF4WImportCategory.DATALOADER.name(), oVm.getDataLoader().getPackage().getFullName());
			}
		}



		for( MViewModelImpl oSubVm : oVm.getSubViewModels()) {
			// for fixed list	

			if ( oSubVm.getType().isList()) {
				
				if(null != oSubVm.getSubViewModels() && !oSubVm.getSubViewModels().isEmpty())
				{
					MEntityImpl oEntity = oSubVm.getSubViewModels().get(0).getEntityToUpdate();
					//oImportDlg.addImport(MW8ImportDelegate.MW8ImportCategory.FACTORIES.name(), oEntity.getFactory().getPackage().getFullName());
				}
				if (oSubVm.getSubViewModels().size() > 0) {
					MEntityImpl oEntity = oSubVm.getSubViewModels().get(0).getEntityToUpdate();
					//oImportDlg.addImport(MW8ImportDelegate.MW8ImportCategory.FACTORIES.name(), oEntity.getFactory().getPackage().getFullName());
				}
			}
		}

		//for picker list
		if(null != oVm.getExternalViewModels() && !oVm.getExternalViewModels().isEmpty())
		{
			for (MViewModelImpl oExtVm : oVm.getExternalViewModels())
			{
				if(oExtVm.getType().equals(ViewModelType.LIST_1__ONE_SELECTED))
				{
					//ViewModelTypeConfiguration clonedVMTypeConf= ViewModelType.LIST_1__ONE_SELECTED.getVMTypeOptionMap().get(oExtVm.getConfigName());	
					//oImportDlg.addImport(MW8ImportDelegate.MW8ImportCategory.VIEWMODEL.name(), clonedVMTypeConf.getInterfaceFullName());
					MDataLoader p_oDataLoader = oVm.getDataLoader();
					if( null != p_oDataLoader && null != p_oDataLoader.getMasterInterface())
					{
						for(MDataLoaderCombo oCombo : p_oDataLoader.getMasterInterface().getCombos() )
						{
							//oImportDlg.addImport(MW8ImportDelegate.MW8ImportCategory.DAO.name(), oCombo.getEntityDao().getPackage().getFullName());
						}	
					}
					else
					{
						if ( oVm.getType().equals(ViewModelType.FIXED_LIST_ITEM)
								&& oExtVm.getEntityToUpdate() !=null
								&& oExtVm.getEntityToUpdate().getDao() !=null) {
							//oImportDlg.addImport(MW8ImportDelegate.MW8ImportCategory.DAO.name(), oExtVm.getEntityToUpdate().getDao().getPackage().getFullName());
							oImportDlg.addImport(MW8ImportDelegate.MW8ImportCategory.VIEWMODEL.name(), oVm.getParent().getPackage().getFullName());
							oImportDlg.addImport(MW8ImportDelegate.MW8ImportCategory.VIEWMODEL.name(), oVm.getParent().getParent().getPackage().getFullName());
						}
					}
				}
			}
		}
		r_xViewModel.getRootElement().add(oImportDlg.toXml());

		return r_xViewModel ;
	}
	
	/**
	 * Add factory import for all attributes of the viewModel that got an expendable entity (recursive)
	 * @param p_oMapping
	 * @param oImportDlg 
	 */
	public void addImportFactoryFromMapping (IVMMappingDesc p_oMapping, MF4WImportDelegate oImportDlg)
	{
		for( MMappingAttribute vmMapAttr : p_oMapping.getMapAttributes().values())
		{
			if(vmMapAttr.getExpandableEntityShortName() != null && !vmMapAttr.getExpandableEntityShortName().isEmpty())
			{
				//oImportDlg.addImport(MW8ImportDelegate.MW8ImportCategory.FACTORIES.name(), vmMapAttr.getExpandableEntityShortName()+"Factory");
			}
		}
		for( MMappingEntity vmMapEntity : p_oMapping.getMapEntities().values())
		{
			addImportFactoryFromMapping( vmMapEntity,oImportDlg );
		}
	}
}
