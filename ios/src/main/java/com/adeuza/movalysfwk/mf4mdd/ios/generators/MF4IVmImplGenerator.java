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
package com.adeuza.movalysfwk.mf4mdd.ios.generators;

import java.util.ArrayList;
import java.util.List;

import org.dom4j.Document;

import com.a2a.adjava.languages.ios.generators.VMImplGenerator;
import com.a2a.adjava.languages.ios.xmodele.MIOSImportDelegate;
import com.a2a.adjava.xmodele.IDomain;
import com.a2a.adjava.xmodele.IModelDictionary;
import com.a2a.adjava.xmodele.IModelFactory;
import com.a2a.adjava.xmodele.MAssociation;
import com.a2a.adjava.xmodele.MAssociation.AssociationType;
import com.a2a.adjava.xmodele.MEntityImpl;
import com.a2a.adjava.xmodele.MViewModelImpl;
import com.a2a.adjava.xmodele.XProject;
import com.a2a.adjava.xmodele.ui.viewmodel.ViewModelType;
import com.a2a.adjava.xmodele.ui.viewmodel.ViewModelTypeConfiguration;
import com.a2a.adjava.xmodele.ui.viewmodel.mappings.IVMMappingDesc;
import com.a2a.adjava.xmodele.ui.viewmodel.mappings.MMappingAttribute;
import com.a2a.adjava.xmodele.ui.viewmodel.mappings.MMappingEntity;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MDataLoader;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MDataLoaderCombo;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFViewModel;
import com.adeuza.movalysfwk.mf4mdd.ios.xmodele.MF4IImportDelegate;

/**
 * @author lmichenaud
 *
 */
public class MF4IVmImplGenerator extends VMImplGenerator {

	
	/**
	 * {@inheritDoc}
	 * @see com.a2a.adjava.generator.impl.ViewModelGenerator#createDocument(com.a2a.adjava.xmodele.MViewModelImpl, com.a2a.adjava.xmodele.XProject)
	 */
	@Override
	protected Document createDocument(MViewModelImpl p_oMViewModel,
			XProject<IDomain<IModelDictionary, IModelFactory>> p_oProject) {
		Document r_xViewModel = super.createDocument(p_oMViewModel, p_oProject);

		MFViewModel oVm = (MFViewModel) p_oMViewModel;

		MF4IImportDelegate oImportDlg = new MF4IImportDelegate(this);
		oImportDlg.addImport(MIOSImportDelegate.MIOSImportCategory.VIEWMODEL.name(), p_oMViewModel.getName());

		if ( oVm.getEntityToUpdate() != null ) {
			MEntityImpl oEntity = oVm.getEntityToUpdate();
			
			//On ajoute en import la factory de l'entité mise à jour par ce view model
			oImportDlg.addImport(MIOSImportDelegate.MIOSImportCategory.FACTORIES.name(), oEntity.getFactory().getName());
			
			List<MEntityImpl> oSubEntities = parseEntityForImports(oEntity, oImportDlg, 0);
			List<MEntityImpl> oSubSubEntities = new ArrayList<>();
			for(MEntityImpl oSubEntity : oSubEntities) {
				oSubSubEntities.addAll(parseEntityForImports(oSubEntity, oImportDlg, 1));
			}
			for(MEntityImpl oSubEntity : oSubSubEntities) {
				parseEntityForImports(oSubEntity, oImportDlg, 2);
			}
			
			
			for( MAssociation oAssociation : oEntity.getAssociations()) {
				if ( !oAssociation.isSelfRef() 
					&& (oAssociation.getAssociationType().equals(AssociationType.MANY_TO_ONE) 
						| oAssociation.getAssociationType().equals(AssociationType.ONE_TO_MANY) 
						|| oAssociation.getAssociationType().equals(AssociationType.ONE_TO_ONE) 
						|| oAssociation.getAssociationType().equals(AssociationType.MANY_TO_MANY))) {
					oImportDlg.addImport(MIOSImportDelegate.MIOSImportCategory.ENTITIES.name(), oAssociation.getRefClass().getName());
					oImportDlg.addImport(MIOSImportDelegate.MIOSImportCategory.FACTORIES.name(), oAssociation.getRefClass().getFactory().getName());
					if ( !oAssociation.getRefClass().isTransient()) {
						oImportDlg.addImport(MIOSImportDelegate.MIOSImportCategory.ENTITIES.name(), oAssociation.getRefClass().getName());
					}
				}
			}
		}

		addImportFactoryFromMapping(oVm.getMapping(), oImportDlg);

		if ( oVm.getDataLoader() != null 
			|| oVm.getType() == ViewModelType.LISTITEM_2 
			|| oVm.getType() == ViewModelType.LISTITEM_3) {
			oImportDlg.addImport(MIOSImportDelegate.MIOSImportCategory.VIEWMODEL.name(), p_oProject.getDomain().getDictionnary().getViewModelCreator().getName());
			if(oVm.getDataLoader() != null) {
				oImportDlg.addImport(MF4IImportDelegate.MF4IImportCategory.DATALOADER.name(), oVm.getDataLoader().getName());
			}
		}



		for( MViewModelImpl oSubVm : oVm.getSubViewModels()) {
			// for fixed list	

			if ( oSubVm.getType().isList()) {
				
				if(null != oSubVm.getSubViewModels() && !oSubVm.getSubViewModels().isEmpty())
				{
					MEntityImpl oEntity = oSubVm.getSubViewModels().get(0).getEntityToUpdate();
					oImportDlg.addImport(MIOSImportDelegate.MIOSImportCategory.FACTORIES.name(), oEntity.getFactory().getName());
				}
				if (oSubVm.getSubViewModels().size() > 0) {
					MEntityImpl oEntity = oSubVm.getSubViewModels().get(0).getEntityToUpdate();
					oImportDlg.addImport(MIOSImportDelegate.MIOSImportCategory.FACTORIES.name(), oEntity.getFactory().getName());
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
					ViewModelTypeConfiguration oClonedVMTypeConf = ViewModelType.LIST_1__ONE_SELECTED.getVMTypeOptionMap().get(oExtVm.getConfigName());	
					oImportDlg.addImport(MIOSImportDelegate.MIOSImportCategory.VIEWMODEL.name(), oClonedVMTypeConf.getInterfaceName());
					MDataLoader oDataLoader = oVm.getDataLoader();
					if( null != oDataLoader && null != oDataLoader.getMasterInterface())
					{
						for(MDataLoaderCombo oCombo : oDataLoader.getMasterInterface().getCombos() )
						{
							oImportDlg.addImport(MIOSImportDelegate.MIOSImportCategory.DAO.name(), oCombo.getEntityDao().getName());
						}	
					}
					else
					{
						if ( oVm.getType().equals(ViewModelType.FIXED_LIST_ITEM)
								&& oExtVm.getEntityToUpdate() !=null
								&& oExtVm.getEntityToUpdate().getDao() !=null) {
							oImportDlg.addImport(MIOSImportDelegate.MIOSImportCategory.DAO.name(), oExtVm.getEntityToUpdate().getDao().getBeanName());
							oImportDlg.addImport(MIOSImportDelegate.MIOSImportCategory.VIEWMODEL.name(), oVm.getParent().getName());
							oImportDlg.addImport(MIOSImportDelegate.MIOSImportCategory.VIEWMODEL.name(), oVm.getParent().getParent().getName());
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
	 * @param p_oMapping mapping
	 * @param p_oImportDlg import delegate
	 */
	public void addImportFactoryFromMapping (IVMMappingDesc p_oMapping, MF4IImportDelegate p_oImportDlg)
	{
		for( MMappingAttribute oVmMapAttr : p_oMapping.getMapAttributes().values())
		{
			if(oVmMapAttr.getExpandableEntityShortName() != null && !oVmMapAttr.getExpandableEntityShortName().isEmpty())
			{
				p_oImportDlg.addImport(MIOSImportDelegate.MIOSImportCategory.FACTORIES.name(), oVmMapAttr.getExpandableEntityShortName()+"+Factory");
			}
		}
		for( MMappingEntity oVmMapEntity : p_oMapping.getMapEntities().values())
		{
			addImportFactoryFromMapping( oVmMapEntity,p_oImportDlg );
		}
	}
	
	/**
	 * Parcourt la liste des entités liées et ajoute les imports nécessaires
	 * @param p_oEntity L'entité en cours de traitement pour ajouter les imports
	 * @param p_oImportDlg Le delegate d'imports.
	 * @return La lite des entités liées à cette entités.
	 */
	private List<MEntityImpl> parseEntityForImports(MEntityImpl p_oEntity, MF4IImportDelegate p_oImportDlg, int p_iDepth) {
		//On ajoute en import les factory des entités associés à cette entité, et aux entités assoicées (récursivement).
		List<MEntityImpl> oSubEntities = new ArrayList<>();

		for( MAssociation oAssociation : p_oEntity.getAssociations()) {
			if(p_iDepth == 0 || p_iDepth == 1|| p_iDepth == 2) {
				if ( !oAssociation.isSelfRef() && 
						(oAssociation.getAssociationType().equals(AssociationType.MANY_TO_ONE) ||
								oAssociation.getAssociationType().equals(AssociationType.ONE_TO_MANY) ||
								oAssociation.getAssociationType().equals(AssociationType.ONE_TO_ONE) ||
								oAssociation.getAssociationType().equals(AssociationType.MANY_TO_MANY))) {
					p_oImportDlg.addImport(MIOSImportDelegate.MIOSImportCategory.ENTITIES.name(), oAssociation.getRefClass().getName());
					p_oImportDlg.addImport(MIOSImportDelegate.MIOSImportCategory.FACTORIES.name(), oAssociation.getRefClass().getFactory().getName());
					if ( !oAssociation.getRefClass().isTransient()) {
						p_oImportDlg.addImport(MIOSImportDelegate.MIOSImportCategory.ENTITIES.name(), oAssociation.getRefClass().getName());
					}
				}
			}

			oSubEntities.add(oAssociation.getRefClass());

		}
		return oSubEntities;
	}
}
