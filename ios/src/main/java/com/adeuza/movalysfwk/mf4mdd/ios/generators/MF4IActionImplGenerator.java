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

import org.dom4j.Document;

import com.a2a.adjava.generator.impl.ActionGenerator;
import com.a2a.adjava.generators.DomainGeneratorContext;
import com.a2a.adjava.languages.ios.xmodele.MIOSImportDelegate;
import com.a2a.adjava.utils.FileTypeUtils;
import com.a2a.adjava.xmodele.IDomain;
import com.a2a.adjava.xmodele.IModelDictionary;
import com.a2a.adjava.xmodele.IModelFactory;
import com.a2a.adjava.xmodele.MAction;
import com.a2a.adjava.xmodele.MActionType;
import com.a2a.adjava.xmodele.XProject;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFViewModel;
import com.adeuza.movalysfwk.mf4mdd.ios.xmodele.MF4IImportDelegate;

/**
 * Action generator
 * @author lmichenaud
 *
 */
public class MF4IActionImplGenerator extends ActionGenerator {

	/**
	 * Package for action
	 */
	public static final String ACTION_PACKAGE = "action";
	
	/**
	 * {@inheritDoc}
	 * @see com.a2a.adjava.generator.impl.ActionGenerator#createAction(com.a2a.adjava.xmodele.MAction, com.a2a.adjava.xmodele.XProject, com.a2a.adjava.generators.DomainGeneratorContext)
	 */
	@Override
	protected void createAction(MAction p_oAction,
			XProject<IDomain<IModelDictionary, IModelFactory>> p_oMProject,
			DomainGeneratorContext p_oGeneratorContext) throws Exception {
		
		if ( p_oAction.getType().equals(MActionType.SAVEDETAIL) 
			|| p_oAction.getType().equals(MActionType.DELETEDETAIL)) {
			super.createAction(p_oAction, p_oMProject, p_oGeneratorContext);
		}
	}
	
	/**
	 * {@inheritDoc}
	 * @see com.a2a.adjava.generator.impl.ActionGenerator#getFilename(com.a2a.adjava.xmodele.MAction, com.a2a.adjava.xmodele.XProject)
	 */
	@Override
	protected String getFilename(MAction p_oAction,
			XProject<IDomain<IModelDictionary, IModelFactory>> p_oMProject) {
		return FileTypeUtils.computeFilenameForIOSImpl(ACTION_PACKAGE, p_oAction.getName(), p_oMProject.getSourceDir());
	}
	
	/**
	 * {@inheritDoc}
	 * @see com.a2a.adjava.generator.impl.ActionGenerator#computeXml(com.a2a.adjava.xmodele.MAction, com.a2a.adjava.xmodele.XProject)
	 */
	@Override
	protected Document computeXml(MAction p_oAction,
			XProject<IDomain<IModelDictionary, IModelFactory>> p_oMProject) {
		Document r_xDoc = super.computeXml(p_oAction, p_oMProject);
		MF4IImportDelegate oImportDlg = new MF4IImportDelegate(this);
		
		oImportDlg.addImport(MIOSImportDelegate.MIOSImportCategory.ACTION.name(), p_oAction.getName());
		oImportDlg.addImport(MIOSImportDelegate.MIOSImportCategory.ENTITIES.name(), p_oAction.getEntity().getName());
		oImportDlg.addImport(MIOSImportDelegate.MIOSImportCategory.FACTORIES.name(), p_oAction.getEntity().getFactory().getName());
		
		// No dao for transient entity
		if ( p_oAction.getDao() != null ) {
			oImportDlg.addImport(MIOSImportDelegate.MIOSImportCategory.DAO.name(), p_oAction.getDao().getName());
		}
		oImportDlg.addImport(MIOSImportDelegate.MIOSImportCategory.VIEWMODEL.name(), p_oAction.getVm().getName());
		oImportDlg.addImport(MIOSImportDelegate.MIOSImportCategory.VIEWMODEL.name(), p_oMProject.getDomain().getDictionnary().getViewModelCreator().getName());
		oImportDlg.addImport(MF4IImportDelegate.MF4IImportCategory.DATALOADER.name(), ((MFViewModel) p_oAction.getVm()).getDataLoader().getName());
		
		r_xDoc.getRootElement().add(oImportDlg.toXml());
		return r_xDoc ;
	}
}
